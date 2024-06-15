//
//  JFKernels.ci.metal
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

#include <CoreImage/CoreImage.h>
using namespace metal;

float random(float2 p){return fract(cos(dot(p,float2(23.14069263277926,2.665144142690225)))*12345.6789);}

//float rand(int x, int y, int z)
//{
//    int seed = x + y * 57 + z * 241;
//    seed= (seed<< 13) ^ seed;
//    return (( 1.0 - ( (seed * (seed * seed * 15731 + 789221) + 1376312589) & 2147483647) / 1073741824.0f) + 1.0f) / 2.0f;
//}

extern "C" {
    
    /*COLOR FILTERS*/
    
    float4 JFBrightness(coreimage::sample_t s, float brightness){
        float3 color = s.rgb + float3(brightness);
        
        return float4(color, s.a);
    }
    
    float4 JFGamma(coreimage::sample_t s, float gamma){
        float denom = min(max(gamma, 0.01), 7.99);
        float g = 1 / denom;
        float3 color = pow(s.rgb, g);
        
        return float4(color, s.a);
    }
    
    float4 JFContrast(coreimage::sample_t s, float contrast){
        float f = (1.01 * (contrast + 1)) / (1 * (1.01 - contrast));
        float3 color = s.rgb - float3(0.5);
        color = color * f;
        color = color + float3(0.5);
        
        return float4(color, s.a);
    }
    
    float4 JFGreyscale(coreimage::sample_t s){
        
        float3 I = float3(0.299 * s.r + 0.587 * s.g + 0.114 * s.b);
        
        return float4(I, s.a);
    }
    
    float4 JFInversion(coreimage::sample_t s){
        
        float3 I = float3(1.0);
        
        return float4(I - s.rgb, s.a);
    }
    
    float4 JFSolarize(coreimage::sample_t s, float threshold){
        float3 color = s.rgb;
        if (color.r >= threshold) {
            color.r = 1 - color.r;
        }
        if (color.g >= threshold) {
            color.g = 1 - color.g;
        }
        if (color.b >= threshold) {
            color.b = 1 - color.b;
        }
        
        return float4(color, s.a);
    }
    
    float4 JFPosterize(coreimage::sample_t s, float intervals){
        float interval = 1 / intervals;
        float3 color = s.rgb;
        
        color.r = floor(color.r / interval) * interval;
        color.g = floor(color.g / interval) * interval;
        color.b = floor(color.b / interval) * interval;
        
        
        return float4(color, s.a);
    }
    
    float4 JFChromaKey(coreimage::sample_t s, float r, float g, float b, float dist, float smooth) {
        
        float maskY = 0.299 * r + 0.587 * g + 0.114 * b;
        float maskCr = 0.7133 * (r - maskY);
        float maskCb = 0.5643 * (b - maskY);
        
        float Y = 0.299 * s.r + 0.587 * s.g + 0.114 * s.b;
        float Cr = 0.7133 * (s.r - Y);
        float Cb = 0.5643 * (s.b - Y);
        
        float blendValue = smoothstep(dist, dist + smooth, distance(float2(Cr, Cb), float2(maskCr, maskCb)));
        return float4(s.rgb, s.a * blendValue);
    }
    
    /*BLEND FILTERS*/
    
    float4 JFNormalOverlayBlend(coreimage::sample_t s, coreimage::sample_t b){
        return mix(s.rgba, b.rgba, b.a);
    }
    
    float4 JFNormalBackgroundBlend(coreimage::sample_t s, coreimage::sample_t b){
        return mix(b.rgba, s.rgba, s.a);
    }
    
    /*BLUR FILTERS*/
    
    float4 JFGlassFilter(coreimage::sampler src, float dist) {
        float2 coords = src.coord();
        float4 s = sample(src, coords);
        float r = random(float2(s.r, coords.x));
        float r2 = random(float2(s.g, coords.y));
        
        float maxDist = ceil(dist);
        float range = maxDist * 2;
        float I = 1 / range;
        
        float iX = floor(r / I) * range;
        float iY = floor(r2 / I) * range;
        
        
        return sample(src, float2(coords.x + iX - maxDist, coords.y + iY - maxDist));
    }
    
    float getGuassianWeight(float dist, float r){
        
        float weight = exp( -dist / (2*r*r) ) / (3.14*2*r*r);
        return weight;
    }
    
    float4 JFGuassianBlurFilter(coreimage::sampler src, float r) {
        float2 coords = src.coord();
        float4 s = sample(src, coords);
        
        float radius = floor(r);
        float3 color = float3(0.0);
        float weightSum = 0;

        for(int x = coords.x - radius; x <= coords.x + radius; x++){
            for(int y = coords.y - radius; y <= coords.y + radius; y++){
                float weight = getGuassianWeight(distance(float2(x, y), coords), radius);
                color += sample(src, float2(x, y)).rgb * weight;
                weightSum += weight;
            }
        }
        
        color /= weightSum;
        
        return float4(color, s.a);
    }
    
    /*EDGE FILTERS*/
    
    float4 JFSobelThresholdFilter(coreimage::sampler src, float threshold, float edgeStrength) {
        
        float2 coords = src.coord();
        float alpha = sample(src, coords).a;
        float bottomLeftIntensity = sample(src, coords + float2(-1, -1)).r;
        float topRightIntensity = sample(src, coords + float2(1, 1)).r;
        float topLeftIntensity = sample(src, coords + float2(1, -1)).r;
        float bottomRightIntensity = sample(src, coords + float2(-1, 1)).r;
        float leftIntensity = sample(src, coords + float2(0, -1)).r;
        float rightIntensity = sample(src, coords + float2(0, 1)).r;
        float bottomIntensity = sample(src, coords + float2(-1, 0)).r;
        float topIntensity = sample(src, coords + float2(1, 0)).r;
        
        float h = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;
        float v = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;
        
        float mag = (length(float2(h, v)) * edgeStrength);
        mag = step(threshold, mag);
        mag = 1.0 - mag;
        
        
        return float4(float3(mag), alpha);
    }
    
    float4 JFComicBookFilter(coreimage::sampler src, float threshold, float edgeStrength, float intervals) {
        
        float2 coords = src.coord();
        float4 s = sample(src, coords);
        float bottomLeftIntensity = sample(src, coords + float2(-1, -1)).r;
        float topRightIntensity = sample(src, coords + float2(1, 1)).r;
        float topLeftIntensity = sample(src, coords + float2(1, -1)).r;
        float bottomRightIntensity = sample(src, coords + float2(-1, 1)).r;
        float leftIntensity = sample(src, coords + float2(0, -1)).r;
        float rightIntensity = sample(src, coords + float2(0, 1)).r;
        float bottomIntensity = sample(src, coords + float2(-1, 0)).r;
        float topIntensity = sample(src, coords + float2(1, 0)).r;
        
        float h = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;
        float v = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;
        
        float mag = (length(float2(h, v)) * edgeStrength);
        mag = step(threshold, mag);
        mag = 1.0 - mag;
        
        float3 color = float3(mag);
        
        if (mag > 0) {
            float interval = 1 / intervals;
            color = s.rgb;
            
            color.r = floor(color.r / interval) * interval;
            color.g = floor(color.g / interval) * interval;
            color.b = floor(color.b / interval) * interval;
        }
        
        return float4(color, s.a);
    }
}
