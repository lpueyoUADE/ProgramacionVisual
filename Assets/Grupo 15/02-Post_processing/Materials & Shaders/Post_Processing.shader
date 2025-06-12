// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Post_Processing"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_GrayScale("GrayScale", Range( 0 , 1)) = 0
		_Posterize("Posterize", Range( 1 , 256)) = 1
		_InvertColors("InvertColors", Range( 0 , 1)) = 1
		_Contrast("Contrast", Range( 0 , 3)) = 1
		_Saturation("Saturation", Range( 0 , 1)) = 0
		_Dithering("Dithering", Range( 0 , 1)) = 0
		_BWDithering("BWDithering", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _Contrast;
			uniform float _Posterize;
			uniform float _GrayScale;
			uniform float _Saturation;
			uniform float _BWDithering;
			uniform float _Dithering;
			uniform float _InvertColors;
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			inline float Dither4x4Bayer( int x, int y )
			{
				const float dither[ 16 ] = {
			 1,  9,  3, 11,
			13,  5, 15,  7,
			 4, 12,  2, 10,
			16,  8, 14,  6 };
				int r = y * 4 + x;
				return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
			}
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float grayscale25 = Luminance(tex2D( _MainTex, uv_MainTex ).rgb);
				float4 temp_cast_2 = (grayscale25).xxxx;
				float4 lerpResult26 = lerp( tex2D( _MainTex, uv_MainTex ) , temp_cast_2 , _GrayScale);
				float div27=256.0/float((int)_Posterize);
				float4 posterize27 = ( floor( lerpResult26 * div27 ) / div27 );
				float3 desaturateInitialColor64 = CalculateContrast(_Contrast,posterize27).rgb;
				float desaturateDot64 = dot( desaturateInitialColor64, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar64 = lerp( desaturateInitialColor64, desaturateDot64.xxx, _Saturation );
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 clipScreen69 = ase_screenPosNorm.xy * _ScreenParams.xy;
				float dither69 = Dither4x4Bayer( fmod(clipScreen69.x, 4), fmod(clipScreen69.y, 4) );
				dither69 = step( dither69, desaturateVar64.x );
				float3 temp_cast_5 = (dither69).xxx;
				float3 lerpResult77 = lerp( ( desaturateVar64 * dither69 ) , temp_cast_5 , _BWDithering);
				float3 lerpResult72 = lerp( desaturateVar64 , lerpResult77 , _Dithering);
				float3 lerpResult30 = lerp( lerpResult72 , saturate( ( 1.0 - lerpResult72 ) ) , _InvertColors);
				

				finalColor = float4( lerpResult30 , 0.0 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;710;1592;281;-1180.51;242.08;2.347926;True;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;22;-1659.1,-64.95422;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;31;-1170.853,-57.4337;Inherit;False;705.3123;317.4495;GrayScale;4;26;24;25;68;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;23;-1499.051,-5.247663;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RelayNode;68;-1139.599,0.123661;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1008.37,171.5779;Inherit;False;Property;_GrayScale;GrayScale;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;25;-928.598,88.09964;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;35;-416.8637,-59.45485;Inherit;False;494.4498;232.17;Posterize;3;27;28;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;26;-648.1522,-2.683636;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-392.0127,75.71645;Inherit;False;Property;_Posterize;Posterize;1;0;Create;True;0;0;0;False;0;False;1;0;1;256;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;47;-398.1355,-9.113901;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosterizeNode;27;-89.51112,-9.068914;Inherit;False;4;2;1;COLOR;0,0,0,0;False;0;INT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;54;105.3552,-60.374;Inherit;False;586.4141;269.7025;Contrast;3;52;51;55;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;52;155.3554,94.16852;Inherit;False;Property;_Contrast;Contrast;3;0;Create;True;0;0;0;False;0;False;1;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;55;157.172,-6.882596;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;67;715.8884,-62.77936;Inherit;False;559.6182;265.6173;Saturation;3;64;66;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;51;467.9696,-10.37405;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;66;765.8884,87.67794;Inherit;False;Property;_Saturation;Saturation;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;65;773.6202,-12.48489;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;74;1309.361,-55.98581;Inherit;False;1035.564;420.0682;Dithering;7;72;77;73;76;75;69;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DesaturateOpNode;64;1075.197,-12.77935;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RelayNode;71;1359.361,-5.985707;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DitheringNode;69;1396.329,167.6934;Inherit;False;0;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;1405.791,259.9627;Inherit;False;Property;_BWDithering;BWDithering;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;1617.884,75.13166;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;77;1856.38,63.62261;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;73;1857.845,194.3071;Inherit;False;Property;_Dithering;Dithering;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;2386.914,-61.96819;Inherit;False;802.608;314.6153;Invert colors;5;30;32;34;29;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;72;2167.439,-4.555074;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RelayNode;48;2411.079,-6.263951;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;29;2570.857,85.59501;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;32;2716.578,160.915;Inherit;False;Property;_InvertColors;InvertColors;2;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;34;2794.669,53.59751;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;30;3028.528,-9.950701;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;3321.922,-12.18938;Float;False;True;-1;2;ASEMaterialInspector;0;2;Post_Processing;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;23;0;22;0
WireConnection;68;0;23;0
WireConnection;25;0;68;0
WireConnection;26;0;68;0
WireConnection;26;1;25;0
WireConnection;26;2;24;0
WireConnection;47;0;26;0
WireConnection;27;1;47;0
WireConnection;27;0;28;0
WireConnection;55;0;27;0
WireConnection;51;1;55;0
WireConnection;51;0;52;0
WireConnection;65;0;51;0
WireConnection;64;0;65;0
WireConnection;64;1;66;0
WireConnection;71;0;64;0
WireConnection;69;0;71;0
WireConnection;75;0;71;0
WireConnection;75;1;69;0
WireConnection;77;0;75;0
WireConnection;77;1;69;0
WireConnection;77;2;76;0
WireConnection;72;0;71;0
WireConnection;72;1;77;0
WireConnection;72;2;73;0
WireConnection;48;0;72;0
WireConnection;29;0;48;0
WireConnection;34;0;29;0
WireConnection;30;0;48;0
WireConnection;30;1;34;0
WireConnection;30;2;32;0
WireConnection;0;0;30;0
ASEEND*/
//CHKSM=9AF4D742494A562ACEDEF80FB980FFAB4105B37D