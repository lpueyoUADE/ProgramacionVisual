// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "8_ToonWater"
{
	Properties
	{
		_FlowMap("FlowMap", 2D) = "white" {}
		_WaterColor("WaterColor", Color) = (0,0.8355699,1,1)
		_DepthPow("DepthPow", Range( 0 , 10)) = 1
		_DepthScale("DepthScale", Range( 0 , 2)) = 0.5
		_WaterHighlights("WaterHighlights", Range( 0 , 1)) = 1
		_DepthBias("DepthBias", Range( 0 , 2)) = 0.5
		_WaterDarkLights("WaterDarkLights", Range( 0 , 1)) = 0.752162
		_FoamScale("FoamScale", Range( 1 , 20)) = 2
		_WaterFoam("WaterFoam", Color) = (1,1,1,1)
		_PanSpeed("PanSpeed", Range( 0 , 5)) = 1
		_DistortionWeight("DistortionWeight", Range( 0 , 1)) = 0.2
		_NoiseScale("NoiseScale", Range( 0 , 20)) = 2
		_DepthFadeColor("DepthFadeColor", Color) = (1,0,0.009994984,1)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _WaterColor;
			uniform float4 _WaterFoam;
			uniform float _WaterDarkLights;
			uniform float _PanSpeed;
			uniform float _FoamScale;
			uniform sampler2D _FlowMap;
			uniform float _DistortionWeight;
			uniform float _NoiseScale;
			uniform float _WaterHighlights;
			uniform float4 _DepthFadeColor;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _DepthBias;
			uniform float _DepthScale;
			uniform float _DepthPow;
			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 temp_cast_0 = (_FoamScale).xx;
				float2 texCoord10 = i.ase_texcoord1.xy * temp_cast_0 + float2( 0,0 );
				float4 tex2DNode18 = tex2D( _FlowMap, texCoord10 );
				float4 appendResult19 = (float4(tex2DNode18.r , tex2DNode18.g , 0.0 , 0.0));
				float4 lerpResult21 = lerp( float4( texCoord10, 0.0 , 0.0 ) , ( appendResult19 + float4( texCoord10, 0.0 , 0.0 ) ) , _DistortionWeight);
				float2 panner13 = ( 1.0 * _Time.y * ( float2( 1,1 ) * _PanSpeed ) + lerpResult21.xy);
				float2 FlowMap38 = panner13;
				float simpleNoise35 = SimpleNoise( FlowMap38*_NoiseScale );
				float Noise42 = simpleNoise35;
				float4 lerpResult54 = lerp( _WaterColor , _WaterFoam , ( ( step( (-1.0 + (_WaterDarkLights - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) , Noise42 ) + step( (-1.0 + (_WaterHighlights - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) , Noise42 ) ) / 2.0 ));
				float4 screenPos = i.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth56 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth56 = abs( ( screenDepth56 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
				
				
				finalColor = saturate( ( lerpResult54 + ( _DepthFadeColor * ( 1.0 - saturate( pow( ( ( distanceDepth56 + _DepthBias ) * _DepthScale ) , _DepthPow ) ) ) ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;598;1592;393;702.8263;690.9008;1.189803;True;False
Node;AmplifyShaderEditor.CommentaryNode;37;-2019.408,-249.1669;Inherit;False;1905.032;708.3416;FlowMap y panneo;12;38;13;21;14;22;20;15;16;19;18;10;11;FlowMap;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1968.408,58.72068;Inherit;False;Property;_FoamScale;FoamScale;7;0;Create;True;0;0;0;False;0;False;2;10;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1674.424,27.31248;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1447.242,-199.1669;Inherit;True;Property;_FlowMap;FlowMap;0;0;Create;True;0;0;0;False;0;False;-1;f8d6e47f6ed31cd4eb05f940fccfdee6;f8d6e47f6ed31cd4eb05f940fccfdee6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;19;-1118.78,-170.8808;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;15;-914.069,208.1814;Inherit;False;Constant;_PanDir;PanDir;2;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-884.2403,-89.53786;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1042.512,115.6485;Inherit;False;Property;_DistortionWeight;DistortionWeight;10;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1025.028,341.2609;Inherit;False;Property;_PanSpeed;PanSpeed;9;0;Create;True;0;0;0;False;0;False;1;0.1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-709.2756,159.4606;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;21;-712.751,-12.37964;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;13;-531.4205,80.02963;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;40;-27.28308,-626.2289;Inherit;False;790.2277;290.4819;Comment;4;42;35;39;36;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-324.0345,-147.4095;Inherit;False;FlowMap;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;70;-10.58092,479.8905;Inherit;False;1154.316;480.6339;Comment;9;56;62;67;57;58;60;59;63;66;Depth Fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;63.62794,-576.2289;Inherit;False;38;FlowMap;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3.872093,-484.1899;Inherit;False;Property;_NoiseScale;NoiseScale;11;0;Create;True;0;0;0;False;0;False;2;2;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;35;274.3015,-578.6163;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;41;-36.35707,-256.034;Inherit;False;1197.344;578.9534;Comment;10;24;28;29;25;30;26;31;32;43;44;Steps;1,1,1,1;0;0
Node;AmplifyShaderEditor.DepthFade;56;39.41908,529.8908;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;131.7551,679.4828;Inherit;False;Property;_DepthBias;DepthBias;5;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;279.047,572.2309;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;167.0147,780.9982;Inherit;False;Property;_DepthScale;DepthScale;3;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;8.45929,71.33125;Inherit;False;Property;_WaterHighlights;WaterHighlights;4;0;Create;True;0;0;0;False;0;False;1;0.8412747;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;4.189895,-193.2437;Inherit;False;Property;_WaterDarkLights;WaterDarkLights;6;0;Create;True;0;0;0;False;0;False;0.752162;0.7726062;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;534.4745,-577.7369;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;356.5827,877.2476;Inherit;False;Property;_DepthPow;DepthPow;2;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;429.1994,636.5822;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;297.3197,241.2937;Inherit;False;42;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;25;295.6512,-207.0742;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;303.7952,-26.67395;Inherit;False;42;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;29;301.2802,73.44453;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;30;510.3735,60.65976;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;59;587.9319,722.3829;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;26;518.535,-200.034;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;758.1893,-82.13292;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;71;1198.861,-771.8097;Inherit;False;520.3417;482.1007;Comment;3;53;6;54;Water Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;74;1200.177,465.2199;Inherit;False;504.1693;364.5724;Comment;2;73;72;Fade Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;63;780.5643,724.8129;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;73;1250.177,515.2199;Inherit;False;Property;_DepthFadeColor;DepthFadeColor;12;0;Create;True;0;0;0;False;0;False;1,0,0.009994984,1;1,0,0.009994984,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;53;1248.861,-497.5091;Inherit;False;Property;_WaterFoam;WaterFoam;8;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;66;935.205,724.5347;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;32;925.8372,-84.10335;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;1256.384,-721.8097;Inherit;False;Property;_WaterColor;WaterColor;1;0;Create;True;0;0;0;False;0;False;0,0.8355699,1,1;0,0.8355699,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1536.806,696.4722;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;54;1536.593,-713.8332;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;1938.637,8.581171;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;65;2096.359,-88.14692;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;69;2331.108,-137.2253;Float;False;True;-1;2;ASEMaterialInspector;100;1;8_ToonWater;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;10;0;11;0
WireConnection;18;1;10;0
WireConnection;19;0;18;1
WireConnection;19;1;18;2
WireConnection;20;0;19;0
WireConnection;20;1;10;0
WireConnection;14;0;15;0
WireConnection;14;1;16;0
WireConnection;21;0;10;0
WireConnection;21;1;20;0
WireConnection;21;2;22;0
WireConnection;13;0;21;0
WireConnection;13;2;14;0
WireConnection;38;0;13;0
WireConnection;35;0;39;0
WireConnection;35;1;36;0
WireConnection;57;0;56;0
WireConnection;57;1;62;0
WireConnection;42;0;35;0
WireConnection;58;0;57;0
WireConnection;58;1;67;0
WireConnection;25;0;24;0
WireConnection;29;0;28;0
WireConnection;30;0;29;0
WireConnection;30;1;44;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;26;0;25;0
WireConnection;26;1;43;0
WireConnection;31;0;26;0
WireConnection;31;1;30;0
WireConnection;63;0;59;0
WireConnection;66;0;63;0
WireConnection;32;0;31;0
WireConnection;72;0;73;0
WireConnection;72;1;66;0
WireConnection;54;0;6;0
WireConnection;54;1;53;0
WireConnection;54;2;32;0
WireConnection;64;0;54;0
WireConnection;64;1;72;0
WireConnection;65;0;64;0
WireConnection;69;0;65;0
ASEEND*/
//CHKSM=9E9F90CABE0225E05492AE981408F89257C32576