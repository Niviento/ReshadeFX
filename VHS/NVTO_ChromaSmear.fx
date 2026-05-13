//=================================================================================================
//
//  NVTO_ChromaSmear.fx
//  by NIVIENTO 2026
//  Steam: https://steamcommunity.com/id/Niviento/
//
//  All code licensed under the MIT license
//
//=================================================================================================

#include "ReShade.fxh"

uniform float NCS_Smear <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 32.0;
	ui_step = 0.01;
	ui_label = "Chroma Smear";
> = 8.0;

uniform float NCS_ChromaDelay <
	ui_type = "slider";
	ui_min = -32.0;
	ui_max = 32.0;
	ui_step = 0.01;
	ui_label = "Chroma Delay";
> = 2.0;

uniform float NCS_LumaSoftness <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 8.0;
	ui_step = 0.01;
	ui_label = "Luma Softness";
> = 0.35;

uniform float NCS_IQSeparation <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 16.0;
	ui_step = 0.01;
	ui_label = "I/Q Separation";
> = 3.0;

uniform float NCS_Amount <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Effect Amount";
> = 1.0;

uniform float NCS_Saturation <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.001;
	ui_label = "Chroma Saturation";
> = 1.0;

float3 NCS_RGBToYIQ(float3 c)
{
	return float3(
		dot(c, float3(0.299, 0.587, 0.114)),
		dot(c, float3(0.596, -0.274, -0.322)),
		dot(c, float3(0.211, -0.523, 0.312))
	);
}

float3 NCS_YIQToRGB(float3 c)
{
	return float3(
		c.x + 0.956 * c.y + 0.621 * c.z,
		c.x - 0.272 * c.y - 0.647 * c.z,
		c.x - 1.106 * c.y + 1.703 * c.z
	);
}

float3 NCS_Read(float2 uv)
{
	uv = clamp(uv, float2(0.0, 0.0), float2(1.0, 1.0));
	return tex2D(ReShade::BackBuffer, uv).rgb;
}

float3 NCS_BlurRGB(float2 uv, float radius)
{
	float2 p = float2(ReShade::PixelSize.x * radius, 0.0);

	float3 c = NCS_Read(uv) * 0.227027;
	c += NCS_Read(uv + p * 1.0) * 0.1945946;
	c += NCS_Read(uv - p * 1.0) * 0.1945946;
	c += NCS_Read(uv + p * 2.0) * 0.1216216;
	c += NCS_Read(uv - p * 2.0) * 0.1216216;
	c += NCS_Read(uv + p * 3.0) * 0.054054;
	c += NCS_Read(uv - p * 3.0) * 0.054054;
	c += NCS_Read(uv + p * 4.0) * 0.016216;
	c += NCS_Read(uv - p * 4.0) * 0.016216;

	return c;
}

float4 PS_NVTO_ChromaSmear(float4 pos : SV_Position, float2 uv : TEXCOORD0) : SV_Target
{
	float3 original = NCS_Read(uv);

	float3 ySource = NCS_BlurRGB(uv, NCS_LumaSoftness);
	float y = NCS_RGBToYIQ(ySource).x;

	float2 iUV = uv + float2(ReShade::PixelSize.x * NCS_ChromaDelay, 0.0);
	float2 qUV = uv + float2(ReShade::PixelSize.x * (NCS_ChromaDelay + NCS_IQSeparation), 0.0);

	float3 iSignal = NCS_RGBToYIQ(NCS_BlurRGB(iUV, NCS_Smear));
	float3 qSignal = NCS_RGBToYIQ(NCS_BlurRGB(qUV, NCS_Smear * 1.35));

	float i = iSignal.y * NCS_Saturation;
	float q = qSignal.z * NCS_Saturation;

	float3 smeared = NCS_YIQToRGB(float3(y, i, q));

	float3 result = lerp(original, smeared, NCS_Amount);

	return float4(saturate(result), 1.0);
}

technique NVTO_ChromaSmear
{
	pass NVTO_ChromaSmear
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_NVTO_ChromaSmear;
	}
}