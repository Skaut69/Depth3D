 ////------------------------//
 ///**SuperDepthAnaglyph3D**///
 //------------------------////

 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //* Depth Map Based 3D post-process shader v1.9.0 Anaglyph 3D																														*//
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

uniform int Alternate_Depth_Map <
	ui_type = "combo";
	ui_items = "Depth Map 0\0Depth Map 1\0Depth Map 2\0Depth Map 3\0Depth Map 4\0Depth Map 5\0Depth Map 6\0Depth Map 7\0Depth Map 8\0Depth Map 9\0Depth Map 10\0Depth Map 11\0Depth Map 12\0Depth Map 13\0Depth Map 14\0Depth Map 15\0Depth Map 16\0Depth Map 17\0Depth Map 18\0Depth Map 19\0Depth Map 20\0Depth Map 21\0Depth Map 22\0Depth Map 23\0Depth Map 24\0Depth Map 25\0Depth Map 26\0Depth Map 27\0Depth Map 28\0Depth Map 29\0Depth Map 30\0";
	ui_label = "Alternate Depth Map";
	ui_tooltip = "Alternate Depth Map for different Games. Read the ReadMeDepth3d.txt, for setting. Each game May and can use a diffrent Alternet Depth Map.";
> = 0;

uniform int Depth <
	ui_type = "drag";
	ui_min = 0; ui_max = 50;
	ui_label = "Depth Slider";
	ui_tooltip = "Determines the amount of Image Warping and Separation between both eyes. You can Override this setting.";
> = 15;

uniform float Convergence <
	ui_type = "drag";
	ui_min = -0.250; ui_max = 0.250;
	ui_label = "Convergence Slider";
	ui_tooltip = "Determines the Convergence point. Default is 0";
> = 0;

uniform int Perspective <
	ui_type = "drag";
	ui_min = -100; ui_max = 100;
	ui_label = "Perspective Slider";
	ui_tooltip = "Determines the perspective point. Default is 0";
> = 0;

uniform int Disocclusion_Type <
	ui_type = "combo";
	ui_items = "Disocclusion Mask Off\0Normal Disocclusion Mask\0Radial Disocclusion Mask\0";
	ui_label = "Disocclusion Type";
	ui_tooltip = "Pick the type of blur you want.";
> = 1;

uniform float Disocclusion_Power <
	ui_type = "drag";
	ui_min = 0; ui_max = 0.5;
	ui_label = "Disocclusion Power";
	ui_tooltip = "Determines the Disocclusion masking of Depth Map. Default is 0.025";
> = 0.025;

uniform bool Depth_Map_View <
	ui_label = "Depth Map View";
	ui_tooltip = "Display the Depth Map. Use This to Work on your Own Depth Map for your game.";
> = false;

uniform bool Depth_Map_Enhancement <
	ui_label = "Depth Map Enhancement";
	ui_tooltip = "Enable Or Dissable Depth Map Enhancement. Default is Off";
> = 0;

uniform float Adjust <
	ui_type = "drag";
	ui_min = 0; ui_max = 1.5;
	ui_label = "Adjust";
	ui_tooltip = "Adjust DepthMap Enhancement, Dehancement occurs past one. Default is 1.0";
> = 1.0;

uniform int Weapon_Depth_Map <
	ui_type = "combo";
	ui_items = "Weapon Depth Map Off\0Custom Weapon Depth Map One\0Custom Weapon Depth Map Two\0Custom Weapon Depth Map Three\0Custom Weapon Depth Map Four\0WDM 1\0WDM 2\0WDM 3\0WDM 4\0WDM 5\0WDM 6\0WDM 7\0WDM 8\0WDM 9\0WDM 10\0WDM 11\0WDM 12\0WDM 13\0";
	ui_label = "Alternate Weapon Depth Map";
	ui_tooltip = "Alternate Weapon Depth Map for different Games. Read the ReadMeDepth3d.txt, for setting.";
> = 0;

uniform float3 Weapon_Adjust <
	ui_type = "drag";
	ui_min = -1.0; ui_max = 1.500;
	ui_label = "Weapon Adjust DepthMap";
	ui_tooltip = "Adjust weapon depth map. Default is (Y 0, X 0.250, Z 1.001)";
> = float3(0.0,0.250,1.001);

uniform float Weapon_Percentage <
	ui_type = "drag";
	ui_min = -1.0; ui_max = 5.0;
	ui_label = "Weapon Percentage";
	ui_tooltip = "Adjust weapon percentage. Default is 5.0";
> = 5.0;

uniform bool Depth_Map_Flip <
	ui_label = "Depth Map Flip";
	ui_tooltip = "Depth Flip if the depth map is Upside Down.";
> = false;

uniform int Custom_Depth_Map <
	ui_type = "combo";
	ui_items = "Custom Off\0Custom One\0Custom Two\0Custom Three\0Custom Four\0Custom Five\0Custom Six\0Custom Seven\0Custom Eight\0Custom Nine\0Custom Ten\0";
	ui_label = "Custom Depth Map";
	ui_tooltip = "Adjust your own Custom Depth Map.";
> = 0;

uniform float2 Near_Far <
	ui_type = "drag";
	ui_min = 0; ui_max = 100;
	ui_label = "Near & Far";
	ui_tooltip = "Adjustment for Near and Far Depth Map Precision.";
> = float2(1,1.5);

uniform int Anaglyph_Colors <
	ui_type = "combo";
	ui_items = "Red/Cyan\0Dubois Red/Cyan\0Green/Magenta\0Dubois Green/Magenta\0InfiniteColor\0";
	ui_label = "Anaglyph Color Mode";
	ui_tooltip = "Select anaglyph colors for your anaglyph glasses, InfiniteColor is for TriOvis Inficolors 3D support.";
> = 0;

uniform float Anaglyph_Desaturation <
	ui_type = "drag";
	ui_min = 0.0; ui_max = 1.0;
	ui_label = "Anaglyph Desaturation";
	ui_tooltip = "Adjust Anaglyph Saturation, Zero is Black & White, One is full color.";
> = 1.0;

uniform int Custom_Sidebars <
	ui_type = "combo";
	ui_items = "Mirrored Edges\0Black Edges\0";
	ui_label = "Edge Selection";
	ui_tooltip = "Select how you like the Edge of the screen to look like.";
> = 1;

uniform bool Eye_Swap <
	ui_label = "Eye Swap";
	ui_tooltip = "Left right image change.";
> = false;

/////////////////////////////////////////////D3D Starts Here/////////////////////////////////////////////////////////////////

#define pix float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT)

texture DepthBufferTex : DEPTH;

sampler DepthBuffer 
	{ 
		Texture = DepthBufferTex; 
	};

texture BackBufferTex : COLOR;

sampler BackBuffer 
	{ 
		Texture = BackBufferTex;
	};

sampler BackBufferMIRROR 
	{ 
		Texture = BackBufferTex;
		AddressU = MIRROR;
		AddressV = MIRROR;
		AddressW = MIRROR;
	};

sampler BackBufferBORDER
	{ 
		Texture = BackBufferTex;
		AddressU = BORDER;
		AddressV = BORDER;
		AddressW = BORDER;
	};

sampler BackBufferCLAMP
	{ 
		Texture = BackBufferTex;
		AddressU = CLAMP;
		AddressV = CLAMP;
		AddressW = CLAMP;
	};
	
texture texCL  { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 
texture texCR  { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 
texture texCC  { Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT/2; Format = RGBA8;}; 
texture texCDM  { Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT/2; Format = RGBA8;};
	
sampler SamplerCLMIRROR
	{
		Texture = texCL;
		AddressU = MIRROR;
		AddressV = MIRROR;
		AddressW = MIRROR;
	};
	
sampler SamplerCLBORDER
	{
		Texture = texCL;
		AddressU = BORDER;
		AddressV = BORDER;
		AddressW = BORDER;
	};
	
sampler SamplerCLCLAMP
	{
		Texture = texCL;
		AddressU = CLAMP;
		AddressV = CLAMP;
		AddressW = CLAMP;
	};

sampler SamplerCRMIRROR
	{
		Texture = texCR;
		AddressU = MIRROR;
		AddressV = MIRROR;
		AddressW = MIRROR;
	};
	
sampler SamplerCRBORDER
	{
		Texture = texCR;
		AddressU = BORDER;
		AddressV = BORDER;
		AddressW = BORDER;
	};
	
sampler SamplerCRCLAMP
	{
		Texture = texCR;
		AddressU = CLAMP;
		AddressV = CLAMP;
		AddressW = CLAMP;
	};
	
sampler SamplerCC
	{
		Texture = texCC;
		AddressU = CLAMP;
		AddressV = CLAMP;
		AddressW = CLAMP;
	};
	
sampler SamplerCDM
	{
		Texture = texCDM;
		AddressU = CLAMP;
		AddressV = CLAMP;
		AddressW = CLAMP;
	};

//Depth Map Information	
float4 SbSdepth(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_Target
{

	 float4 color = 0;

			if (Depth_Map_Flip)
			texcoord.y =  1 - texcoord.y;
	
	float4 depthM = tex2D(DepthBuffer, float2(texcoord.x, texcoord.y));
	float4 WDM = tex2D(DepthBuffer, float2(texcoord.x, texcoord.y));
		
		if (Custom_Depth_Map == 0)
	{	
		//Alien Isolation | Fallout 4 | Firewatch
		if (Alternate_Depth_Map == 0)
		{
		float cF = 1000000000;
		float cN = 1;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Amnesia: The Dark Descent
		if (Alternate_Depth_Map == 1)
		{
		float cF = 1000;
		float cN = 1;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Among The Sleep | Soma
		if (Alternate_Depth_Map == 2)
		{
		float cF = 10;
		float cN = 0.05;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//The Vanishing of Ethan Carter Redux
		if (Alternate_Depth_Map == 3)
		{
		float cF  = 0.0075;
		float cN = 1;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Batman Arkham Knight | Batman Arkham Origins | Batman: Arkham City | BorderLands 2 | Hard Reset | Lords Of The Fallen | The Elder Scrolls V: Skyrim
		if (Alternate_Depth_Map == 4)
		{
		float cF = 50;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Call of Duty: Advance Warfare | Call of Duty: Black Ops 2 | Call of Duty: Ghost | Call of Duty: Infinite Warfare 
		if (Alternate_Depth_Map == 5)
		{
		float cF = 25;
		float cN = 1;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Casltevania: Lord of Shadows - UE | Dead Rising 3
		if (Alternate_Depth_Map == 6)
		{
		float cF = 25;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Doom 2016
		if (Alternate_Depth_Map == 7)
		{
		float cF = 25;
		float cN = 5;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Deadly Premonition:The Directors's Cut
		if (Alternate_Depth_Map == 8)
		{
		float cF = 30;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Dragon Ball Xenoverse | Quake 2 XP
		if (Alternate_Depth_Map == 9)
		{
		float cF = 1;
		float cN = 0.005;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Warhammer: End Times - Vermintide
		if (Alternate_Depth_Map == 10)
		{
		float cF = 7.0;
		float cN = 1.5;
		depthM = (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Dying Light
		if (Alternate_Depth_Map == 11)
		{
		float cF = 100;
		float cN = 0.0075;
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//GTA V
		if (Alternate_Depth_Map == 12)
		{
		float cF  = 10000; 
		float cN = 0.0075; 
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//Magicka 2
		if (Alternate_Depth_Map == 13)
		{
		float cF = 1.025;
		float cN = 0.025;	
		depthM = clamp(pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000)/0.5,0,1.25);
		}
		
		//Middle-earth: Shadow of Mordor
		if (Alternate_Depth_Map == 14)
		{
		float cF = 650;
		float cN = 651;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Naruto Shippuden UNS3 Full Blurst
		if (Alternate_Depth_Map == 15)
		{
		float cF = 150;
		float cN = 0.001;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Shadow warrior(2013)XP
		if (Alternate_Depth_Map == 16)
		{
		float cF = 5;
		float cN = 0.05;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Ryse: Son of Rome
		if (Alternate_Depth_Map == 17)
		{
		float cF = 1.010;
		float cN = 0;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Sleeping Dogs: DE | DreamFall Chapters
		if (Alternate_Depth_Map == 18)
		{
		float cF  = 1;
		float cN = 0.025;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Souls Games
		if (Alternate_Depth_Map == 19)
		{
		float cF = 1.050;
		float cN = 0.025;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Witcher 3
		if (Alternate_Depth_Map == 20)
		{
		float cF = 7.5;
		float cN = 1;	
		depthM = (pow(abs(cN-depthM),cF));
		}

		//Assassin Creed Unity | Just Cause 3
		if (Alternate_Depth_Map == 21)
		{
		float cF = 150;
		float cN = 151;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}	
		
		//Silent Hill: Homecoming
		if (Alternate_Depth_Map == 22)
		{
		float cF = 25;
		float cN = 25.869;
		depthM = clamp(1 - (depthM * cF / (cF - cN) + cN) / depthM,0,255);
		}
		
		//Monstrum DX11
		if (Alternate_Depth_Map == 23)
		{
		float cF = 1.075;	
		float cN = 0;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//S.T.A.L.K.E.R:SoC
		if (Alternate_Depth_Map == 24)
		{
		float cF = 1.001;
		float cN = 0;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Double Dragon Neon
		if (Alternate_Depth_Map == 25)
		{
		float cF = 0.5;
		float cN = 0.150;
		depthM = log(depthM / cN) / log(cF / cN);
		}
		
		//Deus Ex: Mankind Divided
		if (Alternate_Depth_Map == 26)
		{
		float cF = 250;
		float cN = 251;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}	
		
		//The Elder Scrolls V: Skyrim Special Edition
		if (Alternate_Depth_Map == 27)
		{
		float cF = 20;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Rage64|
		if (Alternate_Depth_Map == 28)
		{
		float cF = 50;
		float cN = -0.5;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Through The Woods
		if (Alternate_Depth_Map == 29)
		{
		float cF = 25;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Amnesia: Machine for Pigs
		if (Alternate_Depth_Map == 30)
		{
		float cF = 100;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
	}
	else
	{
	
		//Custom One
		if (Custom_Depth_Map == 1)
		{
		float cF = Near_Far.y; //10+
		float cN = Near_Far.x;//1
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Custom Two
		if (Custom_Depth_Map == 2)
		{
		float cF  = Near_Far.y; //100+
		float cN = Near_Far.x; //0.01-
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//Custom Three
		if (Custom_Depth_Map == 3)
		{
		float cF  = Near_Far.y;//0.025
		float cN = Near_Far.x;//1.0
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Custom Four
		if (Custom_Depth_Map == 4)
		{
		float cF = Near_Far.y;//1000000000 or 1	
		float cN = Near_Far.x;//0 or 13	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Custom Five
		if (Custom_Depth_Map == 5)
		{
		float cF = Near_Far.y;//1
		float cN = Near_Far.x;//0.025
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Custom Six
		if (Custom_Depth_Map == 6)
		{
		float cF = Near_Far.y;//1
		float cN = Near_Far.x;//1.875
		depthM = clamp(1 - (depthM * cF / (cF - cN) + cN) / depthM,0,255); //Infinite reversed-Z. Clamped, not so Infinate anymore.
		}
		
		//Custom Seven
		if (Custom_Depth_Map == 7)
		{
		float cF = Near_Far.y;//1.01	
		float cN = Near_Far.x;//0	
		depthM = clamp(pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000)/0.5,0,1.25);
		}
		
		//Custom Eight
		if (Custom_Depth_Map == 8)
		{
		float cF = Near_Far.y;//1.010+	or 150
		float cN = Near_Far.x;//0 or	151
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Custom Nine
		if (Custom_Depth_Map == 9)
		{
		float cF = Near_Far.y;
		float cN = Near_Far.x;
		depthM = log(depthM / cN) / log(cF / cN);
		}
		
		//Custom Ten
		if (Custom_Depth_Map == 10)
		{
		float cF = Near_Far.y;//5
		float cN = Near_Far.x;//5
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
	}
		
	float4 D;
	float4 depthMFar;
	float4 depthMFarT;
	
	float Adj;
	float Per;
		
		//Custom Weapon Depth Profile One	
		if (Weapon_Depth_Map == 1)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//0.250
		float cWN = Weapon_Adjust.z;//1.001
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Custom Weapon Depth Profile Two
		if (Weapon_Depth_Map == 2)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//-1000
		float cWN = Weapon_Adjust.z;//0.985
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Custom Weapon Depth Profile Three	
		if (Weapon_Depth_Map == 3)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//0.250
		float cWN = Weapon_Adjust.z;//1.001
		WDM = (log(cWF * cWN/WDM - cWF));
		}
		
		//Custom Weapon Depth Profile Four	
		if (Weapon_Depth_Map == 4)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//-0.05
		float cWN = Weapon_Adjust.z;//0.500
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Map One
		if (Weapon_Depth_Map == 5)
		{
		Adj = 0;
		Per = 5;
		float cWF = -1000;
		float cWN = 0.9856;
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Weapon Depth Map Two
		if (Weapon_Depth_Map == 6)
		{
		Adj = 0.001;
		Per = 0.440;
		float cWF = 0.255;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Three
		if (Weapon_Depth_Map == 7)
		{
		Adj = 0.000;
		Per = 0.180;
		float cWF = 0.235;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Four
		if (Weapon_Depth_Map == 8)
		{
		Adj = 0.00000001;
		Per = 0.675;
		float cWF = 10;
		float cWN = 0.0085;
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Weapon Depth Map Five
		if (Weapon_Depth_Map == 9)
		{
		Adj = 0.001;
		Per = 0.525;
		float cWF = 0.080;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Six
		if (Weapon_Depth_Map == 10)
		{
		Adj = 0;
		Per = 0.500;
		float cWF = -1.9;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Seven
		if (Weapon_Depth_Map == 11)
		{
		Adj = 0.125;
		Per = 1;
		float cWF = -1.0;
		float cWN = -0.1;
		WDM = (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Eight
		if (Weapon_Depth_Map == 12)
		{
		Adj = 0.037;
		Per = 5.0;
		float cWF = 0.75;
		float cWN = -1.0;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Nine
		if (Weapon_Depth_Map == 13)
		{
		Adj = 0.000001;
		Per = 5.0;
		float cWF = 0.0045;
		float cWN = 100;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Ten
		if (Weapon_Depth_Map == 14)
		{
		Adj = 0.0;
		Per = 2;
		float cWF = 37.5;
		float cWN = 0.523;
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Weapon Depth Map Eleven
		if (Weapon_Depth_Map == 15)
		{
		Adj = 0.0003;
		Per = 0.625;
		float cWF = 0.625;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Twelve
		if (Weapon_Depth_Map == 16)
		{
		Adj = 0.050;
		Per = 1.0;
		float cWF = 1.5;
		float cWN = 1.7;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Thirteen
		if (Weapon_Depth_Map == 17)
		{
		Adj = 0;
		Per = 0.666;
		float cWF = -0.06;
		float cWN = 0.666;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Map Fourteen
		if (Weapon_Depth_Map == 18)
		{
		Adj = 0;
		Per = 0.500;
		float cWF = -0.0865;
		float cWN = -0.2;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Map Fifteen
		if (Weapon_Depth_Map == 19)
		{
		Adj = 0.000001;
		Per = 5;
		float cWF = 1.6;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Sixteen
		if (Weapon_Depth_Map == 20)
		{
		Adj = 0.00000001;
		Per = 5;
		float cWF = -0.4925;
		float cWN = 0.200;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Profile Seventeen
		if (Weapon_Depth_Map == 21)
		{
		Adj = 0.040;
		Per = 5;
		float cWF = 0.051;
		float cWN = 1.250;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Eighteen
		if (Weapon_Depth_Map == 22)
		{
		Adj = 0;
		Per = 0.580;
		float cWF = -0.005;
		float cWN = 1.5;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Profile Nineteen
		if (Weapon_Depth_Map == 23)
		{
		Adj = 0.0001;
		Per = 5;
		float cWF = 0.025;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Twenty
		if (Weapon_Depth_Map == 24)
		{
		Adj = 0.0001;
		Per = 5;
		float cWF = 0.035;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Twenty One
		if (Weapon_Depth_Map == 25)
		{
		Adj = 0.000010;
		Per = 5;//5
		float cWF = -0.4;
		float cWN = 0.375;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
	float NearDepth;
	
	if (Weapon_Depth_Map == 23 || Weapon_Depth_Map == 20 || Weapon_Depth_Map == 19 || Weapon_Depth_Map == 13 || Weapon_Depth_Map == 8)
	{
	NearDepth = step(depthM.r,Adj/100000);
	}
	else
	{
	NearDepth = step(depthM.r,Adj);
	}
	
	if(Depth_Map_Enhancement == 0)
    {
		if (Weapon_Depth_Map <= 0)
		{
		D = depthM;
		}
		else
		{
		D = lerp(depthM,WDM%Per,NearDepth);
		}
    }
    else
    {
		if (Weapon_Depth_Map <= 0)
		{
		float A = Adjust;
		float cDF = 1.025;
		float cDN = 0;
		depthMFar = pow(abs((exp(depthM * log(cDF + cDN)) - cDN) / cDF),1000);	
		D = lerp(depthMFar,depthM,A);
		}
		else
		{
		float A = Adjust;
		float cDF = 1.025;
		float cDN = 0;
		depthMFar = pow(abs((exp(depthM * log(cDF + cDN)) - cDN) / cDF),1000);	
		D = lerp(lerp(depthMFar,depthM,A),WDM%Per,NearDepth);
		}
    }
    
	color.rgb = D.rrr;
	
	return color;	

}
	
float4 DisocclusionMask(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_Target
{
	float4 color;
	float2 dir;
	float B;
	float Con = 10;
	
	if(Disocclusion_Type > 0 && Disocclusion_Power > 0 && Anaglyph_Colors != 4) 
	{
	
	const float weight[10] = 
	{  
	-0.08,  
	-0.05,  
	-0.03,  
	-0.02,  
	-0.01,  
	0.01,  
	0.02,  
	0.03,  
	0.05,  
	0.08  
	};
	
	if(Disocclusion_Type == 1)
	{
	dir = float2(0.5,0);
	B = Disocclusion_Power;
	}
	
	if(Disocclusion_Type == 2)
	{
	dir = 0.5 - texcoord;
	B = Disocclusion_Power*2;
	}
	
	dir = normalize( dir ); 
	 
	[loop]
	for (int i = -0; i < 10; i++)
	{
	color += tex2D(SamplerCDM,texcoord + dir * weight[i] * B)/Con;
	}
	
	}
	else
	{
	color = tex2D(SamplerCDM,texcoord.xy);
	}
	
	return color;
}  
  
////////////////////////////////////////////////Left/Right Eye////////////////////////////////////////////////////////
void PS_renderLR(in float4 position : SV_Position, in float2 texcoord : TEXCOORD0, out float4 color : SV_Target0 , out float4 colorT: SV_Target1)
{	
	float D;
	float C;
	
	if (Anaglyph_Colors == 4)
			{
			D = 10;
			C = 0.175;
			}
			else
			{
			D = Depth;
			C = Convergence;
			}
			
	
	const float samples[4] = {0.25, 0.50, 0.75, 1};
	float DepthL = 1.0, DepthR = 1.0;
	float2 uv = 0;
	[loop]
	for (int j = 0; j <= 3; ++j) 
	{	
			uv.x = samples[j] * D;
			DepthL =  min(DepthL,tex2D(SamplerCC,float2(texcoord.x+uv.x*pix.x, texcoord.y)).r)/1-C;
			DepthR =  min(DepthR,tex2D(SamplerCC,float2(texcoord.x-uv.x*pix.x, texcoord.y)).r)/1-C;
	}
		if(!Eye_Swap)
		{	
			if(Custom_Sidebars == 0)
			{
			color = tex2D(BackBufferMIRROR, float2(texcoord.xy+float2((DepthL*D),0)*pix.xy));
			colorT = tex2D(BackBufferMIRROR, float2(texcoord.xy-float2((DepthR*D),0)*pix.xy));
			}
			else
			{
			color = tex2D(BackBufferBORDER, float2(texcoord.xy+float2((DepthL*D),0)*pix.xy));
			colorT = tex2D(BackBufferBORDER, float2(texcoord.xy-float2((DepthR*D),0)*pix.xy));
			}
		}
		else
		{		
			if(Custom_Sidebars == 0)
			{
			colorT = tex2D(BackBufferMIRROR, float2(texcoord.xy+float2((DepthL*D),0)*pix.xy));
			color = tex2D(BackBufferMIRROR, float2(texcoord.xy-float2((DepthR*D),0)*pix.xy));
			}
			else
			{
			colorT = tex2D(BackBufferBORDER, float2(texcoord.xy+float2((DepthL*D),0)*pix.xy));
			color = tex2D(BackBufferBORDER, float2(texcoord.xy-float2((DepthR*D),0)*pix.xy));
			}
		}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void PS0(float4 position : SV_Position, float2 texcoord : TEXCOORD0, out float4 color : SV_Target)
{
	if(!Depth_Map_View)
	{
	
	float P = Perspective;
											
				float3 HalfLM = dot(tex2D(SamplerCLMIRROR,float2(texcoord.x + P * pix.x,texcoord.y)).rgb,float3(0.299, 0.587, 0.114));
				float3 HalfRM = dot(tex2D(SamplerCRMIRROR,float2(texcoord.x - P * pix.x,texcoord.y)).rgb,float3(0.299, 0.587, 0.114));
				float3 LM = lerp(HalfLM,tex2D(SamplerCLMIRROR,float2(texcoord.x + P * pix.x,texcoord.y)).rgb,Anaglyph_Desaturation);  
				float3 RM = lerp(HalfRM,tex2D(SamplerCRMIRROR,float2(texcoord.x - P * pix.x,texcoord.y)).rgb,Anaglyph_Desaturation); 
				
				float3 HalfLB = dot(tex2D(SamplerCLBORDER,float2(texcoord.x + P * pix.x,texcoord.y)).rgb,float3(0.299, 0.587, 0.114));
				float3 HalfRB = dot(tex2D(SamplerCRBORDER,float2(texcoord.x - P * pix.x,texcoord.y)).rgb,float3(0.299, 0.587, 0.114));
				float3 LB = lerp(HalfLB,tex2D(SamplerCLBORDER,float2(texcoord.x + P * pix.x,texcoord.y)).rgb,Anaglyph_Desaturation);  
				float3 RB = lerp(HalfRB,tex2D(SamplerCRBORDER,float2(texcoord.x - P * pix.x,texcoord.y)).rgb,Anaglyph_Desaturation); 
				
				float4 C;
				float4 CT;
				
				if(Custom_Sidebars == 0)
				{
				C = float4(LM,1);
				CT = float4(RM,1);
				}
				else
				{
				C = float4(LB,1);
				CT = float4(RB,1);
				}

				
			if (Anaglyph_Colors == 0)
			{
				float4 LeftEyecolor = float4(1.0,0.0,0.0,1.0);
				float4 RightEyecolor = float4(0.0,1.0,1.0,1.0);
				

				color =  (C*LeftEyecolor) + (CT*RightEyecolor);

			}
			else if (Anaglyph_Colors == 1)
			{
			float red = 0.437 * C.r + 0.449 * C.g + 0.164 * C.b
					- 0.011 * CT.r - 0.032 * CT.g - 0.007 * CT.b;
			
			if (red > 1) { red = 1; }   if (red < 0) { red = 0; }

			float green = -0.062 * C.r -0.062 * C.g -0.024 * C.b 
						+ 0.377 * CT.r + 0.761 * CT.g + 0.009 * CT.b;
			
			if (green > 1) { green = 1; }   if (green < 0) { green = 0; }

			float blue = -0.048 * C.r - 0.050 * C.g - 0.017 * C.b 
						-0.026 * CT.r -0.093 * CT.g + 1.234  * CT.b;
			
			if (blue > 1) { blue = 1; }   if (blue < 0) { blue = 0; }


			color = float4(red, green, blue, 0);
			}
			else if (Anaglyph_Colors == 2)
			{
				float4 LeftEyecolor = float4(0.0,1.0,0.0,1.0);
				float4 RightEyecolor = float4(1.0,0.0,1.0,1.0);
				
				color =  (C*LeftEyecolor) + (CT*RightEyecolor);
				
			}
			else if (Anaglyph_Colors == 3)
			{
				
				
			float red = -0.062 * C.r -0.158 * C.g -0.039 * C.b
					+ 0.529 * CT.r + 0.705 * CT.g + 0.024 * CT.b;
			
			if (red > 1) { red = 1; }   if (red < 0) { red = 0; }

			float green = 0.284 * C.r + 0.668 * C.g + 0.143 * C.b 
						- 0.016 * CT.r - 0.015 * CT.g + 0.065 * CT.b;
			
			if (green > 1) { green = 1; }   if (green < 0) { green = 0; }

			float blue = -0.015 * C.r -0.027 * C.g + 0.021 * C.b 
						+ 0.009 * CT.r + 0.075 * CT.g + 0.937  * CT.b;
			
			if (blue > 1) { blue = 1; }   if (blue < 0) { blue = 0; }
					
			color = float4(red, green, blue, 0);
			}
			else
			{
				float3 LeftEyecolor = float3(1.0,0.0,1.0);
				float3 RightEyecolor = float3(0.0,1.0,0.0);
				
				float3 HalfLeftEyecolor = dot(LeftEyecolor,float3(0.299, 0.587, 0.114));
				float3 HalfRightEyecolor = dot(RightEyecolor,float3(0.299, 0.587, 0.114));
				float3 LEC = lerp(HalfLeftEyecolor,LeftEyecolor,1.4);  
				float3 REC = lerp(HalfRightEyecolor,RightEyecolor,1.4); 
				

				color =  (C*float4(LEC,1)) + (CT*float4(REC,1));
				
			}
		}
	else
	{
		color = tex2D(SamplerCDM,texcoord.xy);
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

//*Rendering passes*//

technique SuperDepth_Anaglyph3D
{			
			pass DepthMapPass
		{
			VertexShader = PostProcessVS;
			PixelShader = SbSdepth;
			RenderTarget = texCDM;
		}
			pass DisocclusionPass
		{
			VertexShader = PostProcessVS;
			PixelShader = DisocclusionMask;
			RenderTarget = texCC;
		}
			pass SinglePassStereo
		{
			VertexShader = PostProcessVS;
			PixelShader = PS_renderLR;
			RenderTarget0 = texCL;
			RenderTarget1 = texCR;
		}
			pass Anaglyph
		{
			VertexShader = PostProcessVS;
			PixelShader = PS0;	
		}
}
