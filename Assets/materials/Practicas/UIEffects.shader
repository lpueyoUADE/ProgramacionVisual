// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UIEffects"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_Tinta("Tinta", 2D) = "white" {}
		_Normals("Normals", 2D) = "bump" {}
		_DistortionAmount("DistortionAmount", Range( 0 , 1)) = 0
		_Textura("Textura", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityStandardUtils.cginc"

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform sampler2D _Textura;
			uniform sampler2D _Normals;
			uniform float4 _Textura_ST;
			uniform half _DistortionAmount;
			uniform sampler2D _Tinta;
			uniform float4 _Tinta_ST;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_Textura = IN.texcoord.xy * _Textura_ST.xy + _Textura_ST.zw;
				float2 MainUvs222_g7 = uv_Textura;
				float4 tex2DNode65_g7 = tex2D( _Normals, MainUvs222_g7 );
				float4 appendResult82_g7 = (float4(0.0 , tex2DNode65_g7.g , 0.0 , tex2DNode65_g7.r));
				float2 temp_output_84_0_g7 = (UnpackScaleNormal( appendResult82_g7, _DistortionAmount )).xy;
				float2 temp_output_71_0_g7 = ( temp_output_84_0_g7 + MainUvs222_g7 );
				float4 tex2DNode96_g7 = tex2D( _Textura, temp_output_71_0_g7 );
				float2 uv_Tinta = IN.texcoord.xy * _Tinta_ST.xy + _Tinta_ST.zw;
				
				half4 color = ( tex2DNode96_g7 * tex2D( _Tinta, uv_Tinta ) );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;605;1592;386;1826.083;939.2811;2.052128;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;21;-105.0061,-705.6369;Inherit;True;Property;_Textura;Textura;10;0;Create;True;0;0;0;False;0;False;9fbef4b79ca3b784ba023cb1331520d5;9fbef4b79ca3b784ba023cb1331520d5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;22;-173.7803,-916.2811;Inherit;True;Property;_Tinta;Tinta;7;0;Create;True;0;0;0;False;0;False;-1;f8d6e47f6ed31cd4eb05f940fccfdee6;f8d6e47f6ed31cd4eb05f940fccfdee6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;24;-113.8731,-503.1025;Inherit;True;Property;_Normals;Normals;8;0;Create;True;0;0;0;False;0;False;302951faffe230848aa0d3df7bb70faa;302951faffe230848aa0d3df7bb70faa;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;25;-168.1326,-279.3132;Half;False;Property;_DistortionAmount;DistortionAmount;9;0;Create;True;0;0;0;False;0;False;0;0.2002366;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;20;173.1006,-781.4186;Inherit;False;UI-Sprite Effect Layer;0;;7;789bf62641c5cfe4ab7126850acc22b8;18,204,0,74,0,191,1,225,0,242,0,237,0,249,1,186,0,177,0,182,0,229,0,92,1,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;556.4119,-739.5516;Float;False;True;-1;2;ASEMaterialInspector;0;4;UIEffects;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;20;39;22;0
WireConnection;20;37;21;0
WireConnection;20;75;24;0
WireConnection;20;80;25;0
WireConnection;0;0;20;0
ASEEND*/
//CHKSM=C8ED2A879E4188712CFA77AAE3DF5A04D6845997