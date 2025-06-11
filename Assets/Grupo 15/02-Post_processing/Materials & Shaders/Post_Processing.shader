// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Post_Processing"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_GrayScale("GrayScale", Range( 0 , 1)) = 0
		_Posterize("Posterize", Range( 1 , 10)) = 1
		_InvertColors("InvertColors", Range( 0 , 1)) = 1
		_Contrast("Contrast", Range( 0 , 3)) = 1
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
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _Contrast;
			uniform float _Posterize;
			uniform float _GrayScale;
			uniform float _InvertColors;
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
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
				float4 tex2DNode23 = tex2D( _MainTex, uv_MainTex );
				float grayscale25 = Luminance(tex2DNode23.rgb);
				float4 temp_cast_2 = (grayscale25).xxxx;
				float4 lerpResult26 = lerp( tex2DNode23 , temp_cast_2 , _GrayScale);
				float div27=256.0/float((int)_Posterize);
				float4 posterize27 = ( floor( lerpResult26 * div27 ) / div27 );
				float4 lerpResult30 = lerp( CalculateContrast(_Contrast,posterize27) , saturate( ( 1.0 - CalculateContrast(_Contrast,posterize27) ) ) , _InvertColors);
				

				finalColor = lerpResult30;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;613;1592;378;1347.172;215.8444;1.808558;True;False
Node;AmplifyShaderEditor.CommentaryNode;31;-1640.929,-72.40386;Inherit;False;906.4343;361.1717;GrayScale;4;25;23;24;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;22;-1838.423,-162.9965;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;23;-1590.929,-22.40387;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;25;-1197.551,73.1295;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1249.323,173.6078;Inherit;False;Property;_GrayScale;GrayScale;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-917.1049,-17.65378;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;35;-667.3212,-62.84111;Inherit;False;527.4513;261.1248;Comment;3;28;27;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-634.3269,97.70016;Inherit;False;Property;_Posterize;Posterize;1;0;Create;True;0;0;0;False;0;False;1;0;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;47;-645.107,-12.50025;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;54;-53.41439,-55.91701;Inherit;False;586.4141;269.7025;Contrast;3;52;51;55;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosterizeNode;27;-324.1943,-15.42986;Inherit;False;4;2;1;COLOR;0,0,0,0;False;0;INT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;55;-1.597763,-2.425603;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-3.414413,98.62547;Inherit;False;Property;_Contrast;Contrast;3;0;Create;True;0;0;0;False;0;False;1;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;622.9902,-46.71684;Inherit;False;796.5876;422.9817;Invert colors;5;30;34;32;29;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;51;309.1999,-5.917057;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;48;641.1354,8.98743;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;29;820.2723,133.1926;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;34;1047.301,83.89977;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;994.2651,185.7288;Inherit;False;Property;_InvertColors;InvertColors;2;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;1245.038,5.30068;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1578.297,-17.35181;Float;False;True;-1;2;ASEMaterialInspector;0;2;Post_Processing;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;23;0;22;0
WireConnection;25;0;23;0
WireConnection;26;0;23;0
WireConnection;26;1;25;0
WireConnection;26;2;24;0
WireConnection;47;0;26;0
WireConnection;27;1;47;0
WireConnection;27;0;28;0
WireConnection;55;0;27;0
WireConnection;51;1;55;0
WireConnection;51;0;52;0
WireConnection;48;0;51;0
WireConnection;29;0;48;0
WireConnection;34;0;29;0
WireConnection;30;0;48;0
WireConnection;30;1;34;0
WireConnection;30;2;32;0
WireConnection;0;0;30;0
ASEEND*/
//CHKSM=4D0BD68373EC48AA19334C2B5AADC41A9B7CBB3D