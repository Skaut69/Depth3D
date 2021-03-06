 ////----------------//
 ///**SuperDepth3D**///
 //----------------////

 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //* Depth Map Based 3D post-process shader v1.8.3 L & R Eye																															*//
 //* For Reshade 3.0																																								*//
 //* --------------------------																																						*//
 //* This work is licensed under a Creative Commons Attribution 3.0 Unported License.																								*//
 //* So you are free to share, modify and adapt it for your needs, and even use it for commercial use.																				*//
 //* I would also love to hear about a project you are using it with.																												*//
 //* https://creativecommons.org/licenses/by/3.0/us/																																*//
 //*																																												*//
 //* Have fun,																																										*//
 //* Jose Negrete AKA BlueSkyDefender																																				*//
 //*																																												*//
 //* http://reshade.me/forum/shader-presentation/2128-sidebyside-3d-depth-map-based-stereoscopic-shader																				*//	
 //* ---------------------------------																																				*//
 //*																																												*//
 //* Original work was based on Shader Based on CryTech 3 Dev work http://www.slideshare.net/TiagoAlexSousa/secrets-of-cryengine-3-graphics-technology								*//
 //*																																												*//
 //* 																																												*//
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

uniform int AltDepthMap <
	ui_type = "combo";
	ui_items = "Depth Map 0\0Depth Map 1\0Depth Map 2\0Depth Map 3\0Depth Map 4\0Depth Map 5\0Depth Map 6\0Depth Map 7\0Depth Map 8\0Depth Map 9\0Depth Map 10\0Depth Map 11\0Depth Map 12\0Depth Map 13\0Depth Map 14\0Depth Map 15\0Depth Map 16\0Depth Map 17\0Depth Map 18\0Depth Map 19\0Depth Map 20\0";
	ui_label = "Alternate Depth Map";
	ui_tooltip = "Alternate Depth Map for different Games. Read the ReadMeDepth3d.txt, for setting. Each game May and can use a diffrent AltDepthMap.";
> = 0;

uniform int Depth <
	ui_type = "drag";
	ui_min = 0; ui_max = 30;
	ui_label = "Depth Slider";
	ui_tooltip = "Determines the amount of Image Warping and Separation between both eyes.";
> = 10;

uniform int Perspective <
	ui_type = "drag";
	ui_min = -100; ui_max = 100;
	ui_label = "Perspective Slider";
	ui_tooltip = "Determines the perspective point.";
> = 0;

uniform float blur <
	ui_type = "drag";
	ui_min = 0; ui_max = 25;
	ui_label = "Blur Slider";
	ui_tooltip = "Determines the blur seperation of Depth Map Blur.";
> = 7.5;

uniform bool DepthFlip <
	ui_label = "Depth Flip";
	ui_tooltip = "Depth Flip if the depth map is Upside Down.";
> = false;

uniform bool DepthMap <
	ui_label = "Depth Map View";
	ui_tooltip = "Display the Depth Map. Use This to Work on your Own Depth Map for your game.";
> = false;

uniform int CustomDM <
	ui_type = "combo";
	ui_items = "Custom Off\0Custom One\0Custom Two\0Custom Three\0Custom Four\0Custom Five\0";
	ui_label = "Custom Depth Map";
	ui_tooltip = "Adjust your own Custom Depth Map.";
> = 0;

uniform float Far <
	ui_type = "drag";
	ui_min = 0; ui_max = 5;
	ui_label = "Far";
	ui_tooltip = "Far Depth Map Adjustment.";
> = 1.5;
 
 uniform float Near <
	ui_type = "drag";
	ui_min = 0; ui_max = 5;
	ui_label = "Near";
	ui_tooltip = "Near Depth Map Adjustment.";
> = 1;

uniform int BD <
	ui_type = "combo";
	ui_items = "Off\0Polynomial Distortion\0";
	ui_label = "Barrel Distortion";
	ui_tooltip = "Barrel Distortion for HMD type Displays.";
> = 0;

uniform float Hsquish <
	ui_type = "drag";
	ui_min = 0.5; ui_max = 2;
	ui_label = "Horizontal Squish";
	ui_tooltip = "Horizontal squish cubic distortion value. Default is 1.0.";
> = 1.00;

uniform float Vsquish <
	ui_type = "drag";
	ui_min = 0.5; ui_max = 2;
	ui_label = "Vertical Squish";
	ui_tooltip = "Vertical squish cubic distortion value. Default is 1.0.";
> = 1.0;

uniform int sstbli <
	ui_type = "combo";
	ui_items = "Side by Side\0Top and Bottom\0Line Interlaced\0Checkerboard 3D\0";
	ui_label = "3D Display Mode";
	ui_tooltip = "Side by Side/Top and Bottom/Line Interlaced displays output.";
> = 0;

uniform float Red <
	ui_type = "drag";
	ui_min = 0; ui_max = 1;
	ui_label = "Red Distortion";
	ui_tooltip = "Adjust the Polynomial Distortion Red. Default is 1.0";
> = 1.0;

uniform float Green <
	ui_type = "drag";
	ui_min = 0; ui_max = 1;
	ui_label = "Green Distortion";
	ui_tooltip = "Adjust the Polynomial Distortion Green. Default is 1.0";
> = 1.0;

uniform float Blue <
	ui_type = "drag";
	ui_min = 0; ui_max = 1;
	ui_label = "Blue Distortion";
	ui_tooltip = "Adjust the Polynomial Distortion Blue. Default is 1.0";
> = 1.0;

uniform bool LRRL <
	ui_label = "Eye Swap";
	ui_tooltip = "Left right image change.";
> = false;

/////////////////////////////////////////////D3D Starts Here/////////////////////////////////////////////////////////////////

#define pix float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT)

	
texture texCL  { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 
texture texCR  { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 
texture texCC  { Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 
texture texCDM  { Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT; Format = RGBA32F;};

texture DepthBufferTex : DEPTH;
texture BackBufferTex : COLOR;

sampler BackBuffer 
	{ 
		Texture = BackBufferTex; 
	};

sampler DepthBuffer 
	{ 
		Texture = DepthBufferTex; 
	};

sampler SamplerCL
	{
		Texture = texCL;
		AddressU = BORDER;
		AddressV = BORDER;
		AddressW = BORDER;
		MipFilter = Linear; 
		MinFilter = Linear; 
		MagFilter = Linear;
	};
	
sampler SamplerCR
	{
		Texture = texCR;
		AddressU = BORDER;
		AddressV = BORDER;
		AddressW = BORDER;
		MipFilter = Linear; 
		MinFilter = Linear; 
		MagFilter = Linear;
	};
	
sampler SamplerCC
	{
		Texture = texCC;
		AddressU = BORDER;
		AddressV = BORDER;
		AddressW = BORDER;
		AddressU = CLAMP;
		AddressV = CLAMP;
		AddressW = CLAMP;
	};
	
sampler SamplerCDM
	{
		Texture = texCDM;
		MinFilter = LINEAR;
		MagFilter = LINEAR;
		MipFilter = LINEAR;
		AddressU = CLAMP;
		AddressV = CLAMP;
		AddressW = CLAMP;
	};

//Depth Map Information	
float4 SbSdepth(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_Target
{

	 float4 color = 0;

			if (DepthFlip)
			texcoord.y =  1 - texcoord.y;
	
	float4 depthM = tex2D(DepthBuffer, float2(texcoord.x, texcoord.y));
		
		if (CustomDM == 0)
	{	
		//Alien Isolation | Fallout 4 | Firewatch
		if (AltDepthMap == 0)
		{
		float cF = 1000000000;
		float cN = 1;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Amnesia: The Dark Descent
		if (AltDepthMap == 1)
		{
		float cF = 1000;
		float cN = 1;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Among The Sleep	
		if (AltDepthMap == 2)
		{
		float cF = 10;
		float cN = 0.05;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Assassin Creed Unity
		if (AltDepthMap == 3)
		{
		float cF  = 0.0075;
		float cN = 1;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Batman Arkham Knight | Batman Arkham Origins | Batman: Arkham City | BorderLands 2 | Hard Reset | Lords Of The Fallen | The Elder Scrolls V: Skyrim
		if (AltDepthMap == 4)
		{
		float cF = 50;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Call of Duty: Advance Warfare | Call of Duty: Black Ops 2 | Call of Duty: Ghost
		if (AltDepthMap == 5)
		{
		float cF  = 0.01;
		float cN = 1;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Casltevania: Lord of Shadows - UE
		if (AltDepthMap == 6)
		{
		float cF = 25;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Condemned: Criminal Origins | Rage | Return To Castle Wolfenstine | The Evil Within | Quake 4
		if (AltDepthMap == 7)
		{
		float cF  = 1;
		float cN = 0.0025;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Deadly Premonition:The Directors's Cut
		if (AltDepthMap == 8)
		{
		float cF = 30;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Dragon Ball Xenoverse | Quake 2 XP
		if (AltDepthMap == 9)
		{
		float cF = 1;
		float cN = 0.005;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Warhammer: End Times - Vermintide
		if (AltDepthMap == 10)
		{
		float cF = 1;	
		float cN = 5.5;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Dying Light
		if (AltDepthMap == 11)
		{
		float cF = 100;
		float cN = 0.005;
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//GTA V
		if (AltDepthMap == 12)
		{
		float cF  = 10000; 
		float cN = 0.0075; 
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//Magicka 2
		if (AltDepthMap == 13)
		{
		float cF = 1;
		float cN = 13;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Middle-earth: Shadow of Mordor
		if (AltDepthMap == 14)
		{
		float cF = 30;
		float cN = 1;	
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Naruto Shippuden UNS3 Full Blurst
		if (AltDepthMap == 15)
		{
		float cF = 150;
		float cN = 0.001;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Shadow warrior(2013)XP
		if (AltDepthMap == 16)
		{
		float cF = 5;
		float cN = 0.05;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Ryse: Son of Rome
		if (AltDepthMap == 17)
		{
		float cF = 1000;
		float cN = 10;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Sleeping Dogs: DE | DreamFall Chapters
		if (AltDepthMap == 18)
		{
		float cF  = 1;
		float cN = 0.025;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Souls Games
		if (AltDepthMap == 19)
		{
		float cF = 200;
		float cN = 1;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Witcher 3
		if (AltDepthMap == 20)
		{
		float cF = 100;
		float cN = 0.01;
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
	}
	else
	{
		//Custom One
		if (CustomDM == 1)
		{
		float cF = Far; //10+
		float cN = Near;//1
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Custom Two
		if (CustomDM == 2)
		{
		float cF  = Far; //100+
		float cN = Near; //0.01-
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//Custom Three
		if (CustomDM == 3)
		{
		float cF  = Far;
		float cN = Near;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Custom Four
		if (CustomDM == 4)
		{
		float cF = Far;//1000000000 or 1	
		float cN = Near;//0 or 13	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Custom Five
		if (CustomDM == 5)
		{
		float cF = Far;//1
		float cN = Near;//0.025
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
				
	}

    float4 D = depthM;	

		color.rgb = D.rrr;
		
	return color;	
}
	
void Blur(in float4 position : SV_Position, in float2 texcoord : TEXCOORD0, out float3 color : SV_Target)
{

	float Con = 0.625;
		
	if(blur > 0)
	{
	const float weight[11] = {
		0.082607,
		0.080977,
		0.076276,
		0.069041,
		0.060049,
		0.050187,
		0.040306,
		0.031105,
		0.023066,
		0.016436,
		0.011254
	};
	[loop]
	for (int i = -0; i < 4; i++)
	{
		float currweight = weight[abs(i)];
		color += (tex2D(SamplerCDM,texcoord.xy + float2(1,0) * (float)i * pix.x * blur).rrr * currweight + tex2D(SamplerCDM,texcoord.xy + float2(1,0) * (float)i * pix.x * -blur).rrr * currweight)  / Con;
	}
	}
	else
	{
	color = tex2D(SamplerCDM,texcoord.xy).rrr;
	}
} 
  
////////////////////////////////////////////////Left/Right Eye////////////////////////////////////////////////////////
void PS_renderLR(in float4 position : SV_Position, in float2 texcoord : TEXCOORD0, out float3 color : SV_Target0 , out float3 colorT: SV_Target1)
{	
	const float samples[4] = {0.5, 0.66, 1, 0.25};
	float DepthL = 1.0, DepthR = 1.0;
	float2 uv = 0;
	[loop]
	for (int j = 0; j <= 3; ++j) 
	{	
			uv.x = samples[j] * Depth;
			DepthL=  min(DepthL,tex2D(SamplerCC,float2(texcoord.x+uv.x*pix.x, texcoord.y))).r;
			DepthR=  min(DepthR,tex2D(SamplerCC,float2(texcoord.x-uv.x*pix.x, texcoord.y))).r;
		if(!LRRL)
		{
			//color.rgb = tex2D(SamplerCC, texcoord.xy).rrr;
			
			color.rgb = tex2D(BackBuffer , float2(texcoord.xy+float2(DepthL*Depth,0)*pix.xy)).rgb;
		
			colorT.rgb = tex2D(BackBuffer , float2(texcoord.xy-float2(DepthR*Depth,0)*pix.xy)).rgb;
		}
		else
		{		
			colorT.rgb = tex2D(BackBuffer , float2(texcoord.xy+float2(DepthL*Depth,0)*pix.xy)).rgb;
		
			color.rgb = tex2D(BackBuffer , float2(texcoord.xy-float2(DepthR*Depth,0)*pix.xy)).rgb;
		}
	}
}

////////////////////////////////////////////////////Polynomial_Distortion/////////////////////////////////////////////////////

float2 PD(float2 p, float k1)

{

	
	float r2 = (p.x-0.5) * (p.x-0.5) + (p.y-0.5) * (p.y-0.5);       
	float newRadius = 0.0;

	newRadius = (1 + k1*r2);

	 p.x = newRadius * (p.x-0.5)+0.5;
	 p.y = newRadius * (p.y-0.5)+0.5;
	
	return p;
}

float4 PDL(float2 texcoord)

{		
		float4 color;
		float2 uv_red, uv_green, uv_blue;
		float4 color_red, color_green, color_blue;
		float2 sectorOrigin;

    // Radial distort around center
		sectorOrigin = (texcoord.xy-0.5,0,0);

		uv_red = PD(texcoord.xy-sectorOrigin,Red) + sectorOrigin;
		uv_green = PD(texcoord.xy-sectorOrigin,Green) + sectorOrigin;
		uv_blue = PD(texcoord.xy-sectorOrigin,Blue) + sectorOrigin;

		color_red = tex2D(SamplerCL, uv_red).r;
		color_green = tex2D(SamplerCL, uv_green).g;
		color_blue = tex2D(SamplerCL, uv_blue).b;


		if( ((uv_red.x > 0) && (uv_red.x < 1) && (uv_red.y > 0) && (uv_red.y < 1)))
		{
			color = float4(color_red.x, color_green.y, color_blue.z, 1.0);
		}
		else
		{
			color = float4(0,0,0,1);
		}
		return color;
		
	}
	
	float4 PDR(float2 texcoord)

{		
		float4 color;
		float2 uv_red, uv_green, uv_blue;
		float4 color_red, color_green, color_blue;
		float2 sectorOrigin;

    // Radial distort around center
		sectorOrigin = (texcoord.xy-0.5,0,0);
		

		uv_red = PD(texcoord.xy-sectorOrigin,Red) + sectorOrigin;
		uv_green = PD(texcoord.xy-sectorOrigin,Green) + sectorOrigin;
		uv_blue = PD(texcoord.xy-sectorOrigin,Blue) + sectorOrigin;

		color_red = tex2D(SamplerCR, uv_red).r;
		color_green = tex2D(SamplerCR, uv_green).g;
		color_blue = tex2D(SamplerCR, uv_blue).b;


		if( ((uv_red.x > 0) && (uv_red.x < 1) && (uv_red.y > 0) && (uv_red.y < 1)))
		{
			color = float4(color_red.x, color_green.y, color_blue.z, 1.0);
		}
		else
		{
			color = float4(0,0,0,1);
		}
		return color;
		
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void PS0(float4 position : SV_Position, float2 texcoord : TEXCOORD0, out float3 color : SV_Target)
{
	if(!DepthMap)
	{
	if(sstbli == 0)
	{
	float posH = Hsquish-1;
	float midH = posH*BUFFER_HEIGHT/2*pix.y;
	
	float posV = Vsquish-1;
	float midV = posV*BUFFER_WIDTH/2*pix.x;
	
		if(BD == 0)
		{
		color = texcoord.x < 0.5 ? tex2D(SamplerCL,float2(texcoord.x*2 + Perspective * pix.x,texcoord.y)).rgb : tex2D(SamplerCR,float2(texcoord.x*2-1 - Perspective * pix.x,texcoord.y)).rgb;
		}
		if(BD == 1)
		{
		color = texcoord.x < 0.5 ? PDL(float2(((texcoord.x*2)*Vsquish)-midV + Perspective * pix.x,(texcoord.y*Hsquish)-midH)).rgb : PDR(float2(((texcoord.x*2-1)*Vsquish)-midV - Perspective * pix.x,(texcoord.y*Hsquish)-midH)).rgb;
		}
	
	}
	if(sstbli == 1)
	{
	color = texcoord.y < 0.5 ? tex2D(SamplerCL,float2(texcoord.x + Perspective * pix.x,texcoord.y*2)).rgb : tex2D(SamplerCR,float2(texcoord.x - Perspective * pix.x,texcoord.y*2-1)).rgb;
	}
	if(sstbli == 2)
	{
		float gridL = frac(texcoord.y*(BUFFER_HEIGHT/2));
		
		color = gridL > 0.5 ? tex2D(SamplerCL,float2(texcoord.x + Perspective * pix.x,texcoord.y)).rgb : tex2D(SamplerCR,float2(texcoord.x - Perspective * pix.x,texcoord.y)).rgb;
	}
	if(sstbli == 3)
	{
		float gridy = floor(texcoord.y*(BUFFER_HEIGHT));
		float gridx = floor(texcoord.x*(BUFFER_WIDTH));

		color = (int((gridy+gridx)+(gridy+gridx)) & 2) < 0.5 ? tex2D(SamplerCL,float2(texcoord.x + Perspective * pix.x,texcoord.y)).rgb : tex2D(SamplerCR,float2(texcoord.x - Perspective * pix.x,texcoord.y)).rgb;
	}
	}
	else
	{
	color = tex2D(SamplerCDM,texcoord.xy).rgb;
	}
}


///////////////////////////////////////////////////////////ReShade.fxh/////////////////////////////////////////////////////////////

// Vertex shader generating a triangle covering the entire screen
void PostProcessVS(in uint id : SV_VertexID, out float4 position : SV_Position, out float2 texcoord : TEXCOORD)
{
	texcoord.x = (id == 2) ? 2.0 : 0.0;
	texcoord.y = (id == 1) ? 2.0 : 0.0;
	position = float4(texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
}

///////////////////////////////////////////////Depth Map View//////////////////////////////////////////////////////////////////////

//*Rendering passes*//

technique Super_Depth3D
{
					pass
		{
			VertexShader = PostProcessVS;
			PixelShader = SbSdepth;
			RenderTarget = texCDM;
		}
			pass
		{
			VertexShader = PostProcessVS;
			PixelShader = Blur;
			RenderTarget = texCC;
		}
			pass
		{
			VertexShader = PostProcessVS;
			PixelShader = PS_renderLR;
			RenderTarget0 = texCL;
			RenderTarget1 = texCR;
		}
			pass
		{
			VertexShader = PostProcessVS;
			PixelShader = PS0;
			
		}
}
