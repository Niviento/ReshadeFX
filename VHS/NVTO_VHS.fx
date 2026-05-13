//=================================================================================================
//
//  NVTO_VHS.fx
//  by NIVIENTO 2026
//  Steam: https://steamcommunity.com/id/Niviento/
//
//  All code licensed under the MIT license
//
//=================================================================================================

#include "ReShade.fxh"

texture2D NVTO_SourceTex
{
	Width = BUFFER_WIDTH;
	Height = BUFFER_HEIGHT;
	MipLevels = 1;
	Format = RGBA16F;
};

texture2D NVTO_TapeTex
{
	Width = BUFFER_WIDTH;
	Height = BUFFER_HEIGHT;
	MipLevels = 1;
	Format = RGBA16F;
};

sampler2D NVTO_Source
{
	Texture = NVTO_SourceTex;
	AddressU = Clamp;
	AddressV = Clamp;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};

sampler2D NVTO_Tape
{
	Texture = NVTO_TapeTex;
	AddressU = Clamp;
	AddressV = Clamp;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};

uniform bool NVTO_EnableComposite <
	ui_label = "Enable Composite Processing";
	ui_category = "01 Composite / NTSC";
> = true;

uniform float NVTO_CompositeAmount <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Composite Amount";
	ui_category = "01 Composite / NTSC";
> = 0.85;

uniform float NVTO_LumaSoftness <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 10.0;
	ui_step = 0.01;
	ui_label = "Luma Softness";
	ui_category = "01 Composite / NTSC";
> = 1.15;

uniform float NVTO_ChromaSoftness <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 36.0;
	ui_step = 0.01;
	ui_label = "Chroma Softness";
	ui_category = "01 Composite / NTSC";
> = 9.0;

uniform float NVTO_ChromaDelay <
	ui_type = "slider";
	ui_min = -32.0;
	ui_max = 32.0;
	ui_step = 0.01;
	ui_label = "Chroma Delay";
	ui_category = "01 Composite / NTSC";
> = 2.0;

uniform float NVTO_ChromaBleed <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Chroma Bleed";
	ui_category = "01 Composite / NTSC";
> = 0.40;

uniform float NVTO_DotCrawl <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Dot Crawl";
	ui_category = "01 Composite / NTSC";
> = 0.08;

uniform float NVTO_ChromaNoise <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Chroma Noise";
	ui_category = "01 Composite / NTSC";
> = 0.035;

uniform float NVTO_LineJitter <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Line Jitter";
	ui_category = "02 Tape Tracking";
> = 0.065;

uniform float NVTO_JitterRate <
	ui_type = "slider";
	ui_min = 0.1;
	ui_max = 60.0;
	ui_step = 0.01;
	ui_label = "Jitter Rate";
	ui_category = "02 Tape Tracking";
> = 18.0;

uniform float NVTO_TrackingDrift <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Tracking Drift";
	ui_category = "02 Tape Tracking";
> = 0.0;

uniform float NVTO_RollingTear <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Rolling Tear";
	ui_category = "02 Tape Tracking";
> = 0.045;

uniform float NVTO_HeadSwitch <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Head Switching";
	ui_category = "02 Tape Tracking";
> = 0.18;

uniform float NVTO_HeadHeight <
	ui_type = "slider";
	ui_min = 0.02;
	ui_max = 0.30;
	ui_step = 0.001;
	ui_label = "Head Switch Height";
	ui_category = "02 Tape Tracking";
> = 0.11;

uniform float NVTO_VerticalSlip <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Vertical Slip";
	ui_category = "02 Tape Tracking";
> = 0.010;

uniform float NVTO_TapeNoise <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Tape Noise";
	ui_category = "03 Tape Damage";
> = 0.12;

uniform float NVTO_FineGrain <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 0.35;
	ui_step = 0.001;
	ui_label = "Fine Grain";
	ui_category = "03 Tape Damage";
> = 0.030;

uniform float NVTO_LineSparks <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Line Sparks";
	ui_category = "03 Tape Damage";
> = 0.12;

uniform float NVTO_Dropouts <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "White Dropouts";
	ui_category = "03 Tape Damage";
> = 0.055;

uniform float NVTO_DropoutWidth <
	ui_type = "slider";
	ui_min = 0.5;
	ui_max = 80.0;
	ui_step = 0.01;
	ui_label = "Dropout Width";
	ui_category = "03 Tape Damage";
> = 14.0;

uniform float NVTO_TapeBands <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Tape Bands";
	ui_category = "03 Tape Damage";
> = 0.035;

uniform float NVTO_RGBDrift <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 8.0;
	ui_step = 0.01;
	ui_label = "RGB Channel Drift";
	ui_category = "04 VHS Output";
> = 0.95;

uniform float NVTO_Scanlines <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Scanlines";
	ui_category = "04 VHS Output";
> = 0.0;

uniform float NVTO_ScanSharpness <
	ui_type = "slider";
	ui_min = 0.5;
	ui_max = 8.0;
	ui_step = 0.01;
	ui_label = "Scanline Sharpness";
	ui_category = "04 VHS Output";
> = 2.2;

uniform float NVTO_Interlace <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Interlace Flicker";
	ui_category = "04 VHS Output";
> = 0.08;

uniform float NVTO_Curvature <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 0.30;
	ui_step = 0.001;
	ui_label = "Screen Curvature";
	ui_category = "04 VHS Output";
> = 0.035;

uniform float NVTO_EdgeFade <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 0.12;
	ui_step = 0.001;
	ui_label = "Edge Fade";
	ui_category = "04 VHS Output";
> = 0.006;

uniform float NVTO_Vignette <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Vignette";
	ui_category = "04 VHS Output";
> = 0.16;

uniform float NVTO_Brightness <
	ui_type = "slider";
	ui_min = 0.25;
	ui_max = 3.0;
	ui_step = 0.001;
	ui_label = "Brightness";
	ui_category = "05 Color";
> = 1.03;

uniform float NVTO_Contrast <
	ui_type = "slider";
	ui_min = 0.25;
	ui_max = 3.0;
	ui_step = 0.001;
	ui_label = "Contrast";
	ui_category = "05 Color";
> = 1.06;

uniform float NVTO_Saturation <
	ui_type = "slider";
	ui_min = 0.0;
	ui_max = 2.5;
	ui_step = 0.001;
	ui_label = "Saturation";
	ui_category = "05 Color";
> = 0.92;

uniform float NVTO_Gamma <
	ui_type = "slider";
	ui_min = 0.5;
	ui_max = 2.5;
	ui_step = 0.001;
	ui_label = "Gamma";
	ui_category = "05 Color";
> = 1.0;

uniform float NVTO_Tint <
	ui_type = "slider";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Green / Magenta Tint";
	ui_category = "05 Color";
> = 0.0;

uniform float NVTO_Temperature <
	ui_type = "slider";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 0.001;
	ui_label = "Warm / Cool Shift";
	ui_category = "05 Color";
> = 0.0;

uniform float NVTO_Timer < source = "timer"; >;
uniform int NVTO_FrameCount < source = "framecount"; >;

float NVTO_Mod(float x, float y)
{
	return x - y * floor(x / y);
}

float NVTO_Hash11(float n)
{
	return frac(sin(n) * 43758.5453123);
}

float NVTO_Hash12(float2 p)
{
	p = frac(p * float2(443.8975, 397.2973));
	p += dot(p, p + 19.1919);
	return frac(p.x * p.y);
}

float NVTO_Noise1(float x)
{
	float i = floor(x);
	float f = frac(x);
	float a = NVTO_Hash11(i);
	float b = NVTO_Hash11(i + 1.0);
	float u = f * f * (3.0 - 2.0 * f);
	return lerp(a, b, u);
}

float NVTO_Noise2(float2 p)
{
	float2 i = floor(p);
	float2 f = frac(p);

	float a = NVTO_Hash12(i);
	float b = NVTO_Hash12(i + float2(1.0, 0.0));
	float c = NVTO_Hash12(i + float2(0.0, 1.0));
	float d = NVTO_Hash12(i + float2(1.0, 1.0));

	float2 u = f * f * (3.0 - 2.0 * f);

	return lerp(lerp(a, b, u.x), lerp(c, d, u.x), u.y);
}

float NVTO_TimeNoise(float seed, float speed)
{
	float t = NVTO_Timer * 0.001 * speed;
	float i = floor(t);
	float f = frac(t);

	float a = NVTO_Hash12(float2(seed, i));
	float b = NVTO_Hash12(float2(seed, i + 1.0));

	float u = f * f * (3.0 - 2.0 * f);

	return lerp(a, b, u);
}

float3 NVTO_RGBToYIQ(float3 c)
{
	return float3(
		dot(c, float3(0.299, 0.587, 0.114)),
		dot(c, float3(0.596, -0.274, -0.322)),
		dot(c, float3(0.211, -0.523, 0.312))
	);
}

float3 NVTO_YIQToRGB(float3 c)
{
	return float3(
		c.x + 0.956 * c.y + 0.621 * c.z,
		c.x - 0.272 * c.y - 0.647 * c.z,
		c.x - 1.106 * c.y + 1.703 * c.z
	);
}

float3 NVTO_ReadBack(float2 uv)
{
	uv = clamp(uv, float2(0.0, 0.0), float2(1.0, 1.0));
	return tex2D(ReShade::BackBuffer, uv).rgb;
}

float3 NVTO_ReadSource(float2 uv)
{
	uv = clamp(uv, float2(0.0, 0.0), float2(1.0, 1.0));
	return tex2D(NVTO_Source, uv).rgb;
}

float3 NVTO_ReadTape(float2 uv)
{
	uv = clamp(uv, float2(0.0, 0.0), float2(1.0, 1.0));
	return tex2D(NVTO_Tape, uv).rgb;
}

float3 NVTO_BlurSource(float2 uv, float radius)
{
	float2 px = float2(ReShade::PixelSize.x * radius, 0.0);

	float3 c = NVTO_ReadSource(uv) * 0.28;
	c += NVTO_ReadSource(uv + px * 1.0) * 0.20;
	c += NVTO_ReadSource(uv - px * 1.0) * 0.20;
	c += NVTO_ReadSource(uv + px * 2.0) * 0.12;
	c += NVTO_ReadSource(uv - px * 2.0) * 0.12;
	c += NVTO_ReadSource(uv + px * 4.0) * 0.04;
	c += NVTO_ReadSource(uv - px * 4.0) * 0.04;

	return c;
}

float3 NVTO_CompositeProcess(float2 uv)
{
	float3 original = NVTO_ReadSource(uv);

	if (!NVTO_EnableComposite)
	{
		return original;
	}

	float3 lumaSample = NVTO_RGBToYIQ(NVTO_BlurSource(uv, NVTO_LumaSoftness));
	float y = lumaSample.x;

	float2 iUV = uv + float2(ReShade::PixelSize.x * NVTO_ChromaDelay, 0.0);
	float2 qUV = uv + float2(ReShade::PixelSize.x * (NVTO_ChromaDelay + NVTO_ChromaSoftness * 0.45), 0.0);

	float3 iSample = NVTO_RGBToYIQ(NVTO_BlurSource(iUV, NVTO_ChromaSoftness));
	float3 qSample = NVTO_RGBToYIQ(NVTO_BlurSource(qUV, NVTO_ChromaSoftness * 1.35));

	float i = iSample.y;
	float q = qSample.z;

	float bleed = y * NVTO_ChromaBleed * 0.035;
	i += bleed;
	q -= bleed;

	float row = floor(uv.y * ReShade::ScreenSize.y);
	float chromaRand = NVTO_TimeNoise(row * 0.071 + 40.0, 22.0) - 0.5;

	i += chromaRand * NVTO_ChromaNoise * y;
	q -= chromaRand * NVTO_ChromaNoise * y;

	float2 pixel = floor(uv * ReShade::ScreenSize);
	float field = NVTO_Mod(float(NVTO_FrameCount), 2.0);
	float crawl = NVTO_Mod(pixel.x + pixel.y + field, 2.0) * 2.0 - 1.0;

	float yLeft = NVTO_RGBToYIQ(NVTO_ReadSource(uv - float2(ReShade::PixelSize.x, 0.0))).x;
	float yRight = NVTO_RGBToYIQ(NVTO_ReadSource(uv + float2(ReShade::PixelSize.x, 0.0))).x;
	float edge = clamp(abs(yRight - yLeft) * 7.0, 0.0, 1.0);

	y += crawl * NVTO_DotCrawl * edge * 0.020;
	i += crawl * NVTO_DotCrawl * edge * 0.012;
	q -= crawl * NVTO_DotCrawl * edge * 0.012;

	float3 processed = NVTO_YIQToRGB(float3(y, i, q));

	return lerp(original, processed, NVTO_CompositeAmount);
}

float2 NVTO_TapeUV(float2 uv)
{
	float t = NVTO_Timer * 0.001;
	float row = floor(uv.y * ReShade::ScreenSize.y);

	float fastLine = NVTO_TimeNoise(row * 0.017 + 10.0, NVTO_JitterRate) - 0.5;
	float slowLine = NVTO_TimeNoise(row * 0.061 + 80.0, NVTO_JitterRate * 0.23) - 0.5;
	float lineShift = fastLine * 0.75 + slowLine * 0.25;

	uv.x += lineShift * ReShade::PixelSize.x * 110.0 * NVTO_LineJitter;

	float band = floor(uv.y * 28.0);
	float bandShift = NVTO_TimeNoise(band * 13.0 + 150.0, 2.2) - 0.5;
	float globalShift = NVTO_TimeNoise(240.0, 0.45) - 0.5;

	uv.x += (bandShift * 0.45 + globalShift * 0.55) * ReShade::PixelSize.x * 180.0 * NVTO_TrackingDrift;

	float tearClock = t * 0.42;
	float tearIndex = floor(tearClock);
	float tearProgress = frac(tearClock);

	float tearStart = NVTO_Hash12(float2(tearIndex, 40.0));
	float tearY = frac(tearStart + tearProgress * 0.85);

	float tearDistance = abs(uv.y - tearY);
	tearDistance = min(tearDistance, 1.0 - tearDistance);

	float tearWidth = lerp(350.0, 1800.0, NVTO_Hash12(float2(tearIndex, 90.0)));
	float tearMask = 1.0 / (1.0 + tearDistance * tearDistance * tearWidth);
	float tearDirection = NVTO_Hash12(float2(tearIndex, 120.0)) - 0.5;

	uv.x += tearMask * tearDirection * 0.10 * NVTO_RollingTear;

	float slip = NVTO_TimeNoise(340.0, 0.55) - 0.5;
	uv.y += slip * ReShade::PixelSize.y * 90.0 * NVTO_VerticalSlip;
	uv.y = frac(uv.y);

	float head = smoothstep(1.0 - NVTO_HeadHeight, 1.0, uv.y);
	float headLine = NVTO_TimeNoise(row * 0.19 + 450.0, 32.0) - 0.5;
	float headBlock = NVTO_TimeNoise(510.0, 7.0) - 0.5;

	uv.x += head * (headLine * 0.75 + headBlock * 0.25) * ReShade::PixelSize.x * 320.0 * NVTO_HeadSwitch;

	return uv;
}

float3 NVTO_TapeDamage(float3 col, float2 uv)
{
	float t = NVTO_Timer * 0.001;
	float2 pixel = floor(uv * ReShade::ScreenSize);
	float row = floor(uv.y * ReShade::ScreenSize.y);

	float grain = NVTO_Hash12(pixel + float2(floor(t * 73.0), floor(t * 127.0))) - 0.5;
	col += grain * NVTO_FineGrain;

	float tapeField = NVTO_Noise2(float2(uv.x * 190.0 + t * 7.0, uv.y * 140.0 - t * 18.0));
	float tapeLines = NVTO_Noise1(row * 0.035 + t * 2.0);
	float tape = (tapeField * tapeLines - 0.35) * NVTO_TapeNoise;
	col += tape;

	float sparkChance = NVTO_Hash12(float2(row, floor(t * 38.0)));
	float sparkGate = step(1.0 - NVTO_LineSparks * 0.045, sparkChance);
	float sparkShape = NVTO_Noise1(uv.x * 150.0 + row * 0.3 + t * 29.0);
	col += sparkGate * sparkShape * NVTO_LineSparks * 0.28;

	float dropoutChance = NVTO_Hash12(float2(row * 0.73, floor(t * 32.0)));
	float dropoutGate = step(1.0 - NVTO_Dropouts * 0.05, dropoutChance);

	float dropoutX = NVTO_Hash12(float2(row, floor(t * 13.0) + 30.0));
	float dropoutWidth = ReShade::PixelSize.x * NVTO_DropoutWidth;

	float dropout = 1.0 - smoothstep(0.0, dropoutWidth, abs(uv.x - dropoutX));
	float dropoutNoise = NVTO_Hash12(pixel + float2(90.0, floor(t * 88.0)));

	col = lerp(col, float3(1.0, 1.0, 1.0), dropoutGate * dropout * dropoutNoise * 0.85);

	float bandClock = t * 0.18;
	float bandY = frac(NVTO_Hash12(float2(floor(bandClock), 600.0)) + frac(bandClock));
	float bandDist = abs(uv.y - bandY);
	bandDist = min(bandDist, 1.0 - bandDist);

	float bandMask = 1.0 / (1.0 + bandDist * bandDist * 420.0);
	float bandPower = (NVTO_TimeNoise(710.0, 1.4) - 0.5) * NVTO_TapeBands;

	col += bandMask * bandPower;
	col *= 1.0 + bandMask * NVTO_TapeBands * 0.18;

	float head = smoothstep(1.0 - NVTO_HeadHeight, 1.0, uv.y);
	float headNoise = NVTO_Hash12(pixel + float2(floor(t * 115.0), 40.0)) - 0.5;
	col += head * headNoise * NVTO_HeadSwitch * 0.22;

	return col;
}

float2 NVTO_CRTUV(float2 uv)
{
	float2 p = uv - 0.5;
	float r = dot(p, p);
	p *= 1.0 + r * NVTO_Curvature;
	return p + 0.5;
}

float NVTO_FrameMask(float2 uv)
{
	float e = max(NVTO_EdgeFade, 0.0001);
	float x = smoothstep(0.0, e, uv.x) * smoothstep(0.0, e, 1.0 - uv.x);
	float y = smoothstep(0.0, e, uv.y) * smoothstep(0.0, e, 1.0 - uv.y);
	return x * y;
}

float NVTO_ScanlineMask(float2 uv)
{
	float line = frac(uv.y * ReShade::ScreenSize.y);
	float tri = abs(line * 2.0 - 1.0);
	float scan = pow(tri, NVTO_ScanSharpness);
	return lerp(1.0 - NVTO_Scanlines, 1.0, scan);
}

float NVTO_InterlaceMask(float2 uv)
{
	float line = floor(uv.y * ReShade::ScreenSize.y);
	float field = NVTO_Mod(float(NVTO_FrameCount), 2.0);
	float v = NVTO_Mod(line + field, 2.0);
	return lerp(1.0, 0.82, v * NVTO_Interlace);
}

float NVTO_VignetteMask(float2 uv)
{
	float2 v = uv * (1.0 - uv);
	float vig = clamp(v.x * v.y * 16.0, 0.0, 1.0);
	vig = pow(vig, 0.42);
	return lerp(1.0, vig, NVTO_Vignette);
}

float3 NVTO_Grade(float3 c)
{
	float l = dot(c, float3(0.2126, 0.7152, 0.0722));

	c = lerp(float3(l, l, l), c, NVTO_Saturation);
	c = (c - 0.5) * NVTO_Contrast + 0.5;
	c *= NVTO_Brightness;

	float3 temp = float3(
		1.0 + NVTO_Temperature * 0.08,
		1.0,
		1.0 - NVTO_Temperature * 0.08
	);

	float3 tint = float3(
		1.0 + NVTO_Tint * 0.035,
		1.0 - abs(NVTO_Tint) * 0.025,
		1.0 - NVTO_Tint * 0.035
	);

	c *= temp * tint;
	c = pow(max(c, float3(0.0, 0.0, 0.0)), float3(1.0 / NVTO_Gamma, 1.0 / NVTO_Gamma, 1.0 / NVTO_Gamma));

	return c;
}

float4 PS_NVTO_Copy(float4 pos : SV_Position, float2 uv : TEXCOORD0) : SV_Target
{
	return tex2D(ReShade::BackBuffer, uv);
}

float4 PS_NVTO_Composite(float4 pos : SV_Position, float2 uv : TEXCOORD0) : SV_Target
{
	float3 col = NVTO_CompositeProcess(uv);
	return float4(col, 1.0);
}

float4 PS_NVTO_Tape(float4 pos : SV_Position, float2 uv : TEXCOORD0) : SV_Target
{
	float2 tapeUV = NVTO_TapeUV(uv);
	float3 col = NVTO_ReadTape(tapeUV);
	col = NVTO_TapeDamage(col, uv);
	return float4(clamp(col, 0.0, 1.0), 1.0);
}

float4 PS_NVTO_Final(float4 pos : SV_Position, float2 uv : TEXCOORD0) : SV_Target
{
	float2 crtUV = NVTO_CRTUV(uv);
	float frame = NVTO_FrameMask(crtUV);

	if (frame <= 0.0001)
	{
		return float4(0.0, 0.0, 0.0, 1.0);
	}

	float driftR = (NVTO_TimeNoise(800.0, 1.7) - 0.5) * NVTO_RGBDrift;
	float driftG = (NVTO_TimeNoise(801.0, 1.1) - 0.5) * NVTO_RGBDrift * 0.45;
	float driftB = (NVTO_TimeNoise(802.0, 1.5) - 0.5) * NVTO_RGBDrift;

	float2 rUV = crtUV + float2(ReShade::PixelSize.x * driftR, ReShade::PixelSize.y * driftR * 0.25);
	float2 gUV = crtUV + float2(ReShade::PixelSize.x * driftG, 0.0);
	float2 bUV = crtUV - float2(ReShade::PixelSize.x * driftB, ReShade::PixelSize.y * driftB * 0.20);

	float r = NVTO_ReadSource(rUV).r;
	float g = NVTO_ReadSource(gUV).g;
	float b = NVTO_ReadSource(bUV).b;

	float3 col = float3(r, g, b);

	col *= NVTO_ScanlineMask(crtUV);
	col *= NVTO_InterlaceMask(crtUV);
	col *= NVTO_VignetteMask(crtUV);

	col = NVTO_Grade(col);
	col *= frame;

	return float4(clamp(col, 0.0, 1.0), 1.0);
}

technique NVTO_VHS
{
	pass Copy
	{
		RenderTarget = NVTO_SourceTex;
		VertexShader = PostProcessVS;
		PixelShader = PS_NVTO_Copy;
	}

	pass Composite
	{
		RenderTarget = NVTO_TapeTex;
		VertexShader = PostProcessVS;
		PixelShader = PS_NVTO_Composite;
	}

	pass Tape
	{
		RenderTarget = NVTO_SourceTex;
		VertexShader = PostProcessVS;
		PixelShader = PS_NVTO_Tape;
	}

	pass Final
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_NVTO_Final;
	}
}