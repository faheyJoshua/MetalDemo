//
//  Shaders.metal
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

#include <metal_stdlib>
using namespace metal;


struct AdjustSaturationUniforms {
    float saturationFactor;
};

kernel void adjustSaturation(texture2d<float, access::read> inTexture [[texture(0)]],
                         texture2d<float, access::write> outTexture [[texture(1)]],
                         constant AdjustSaturationUniforms &uniforms [[buffer(0)]],
                         uint2 gid [[thread_position_in_grid]]) {
    float4 inColor = inTexture.read(gid);
    float value = dot(inColor.rgb, float3(0.299, 0.587, 0.114));
    float4 grayColor(value, value, value, 1.0);
    float4 outColor = mix(grayColor, inColor, uniforms.saturationFactor);
    outTexture.write(outColor, gid);
}
