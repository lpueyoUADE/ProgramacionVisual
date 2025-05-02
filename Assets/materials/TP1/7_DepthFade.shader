// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "7_DepthFade"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_WaterColor("WaterColor", Color) = (1,0,0,0)
		_NormalFactor("NormalFactor", Range( 0 , 5)) = 1
		_Normals("Normals", 2D) = "bump" {}
		_HeightFactor2("Height Factor", Range( 0 , 10)) = 1
		_VoronoiScale2("Voronoi Scale", Range( 0 , 10)) = 5
		_TimeFactor2("Time Factor", Range( 0 , 10)) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform float _VoronoiScale2;
		uniform float _TimeFactor2;
		uniform float _HeightFactor2;
		uniform float4 _WaterColor;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _Normals;
		uniform float4 _Normals_ST;
		uniform float _NormalFactor;
		uniform float _EdgeLength;


		float2 voronoihash24( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi24( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash24( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime20 = _Time.y * _TimeFactor2;
			float time24 = mulTime20;
			float2 coords24 = v.texcoord.xy * _VoronoiScale2;
			float2 id24 = 0;
			float2 uv24 = 0;
			float voroi24 = voronoi24( coords24, time24, id24, uv24, 0 );
			v.vertex.xyz += ( voroi24 * float3(0,1,0) * _HeightFactor2 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 appendResult12 = (float4(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g , 0.0 , 0.0));
			float2 uv_Normals = i.uv_texcoord * _Normals_ST.xy + _Normals_ST.zw;
			float4 screenColor13 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( appendResult12 + float4( UnpackScaleNormal( tex2D( _Normals, uv_Normals ), _NormalFactor ) , 0.0 ) ).xy);
			o.Albedo = ( _WaterColor * screenColor13 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;588;1515;403;2404.033;-462.8991;2.217117;True;False
Node;AmplifyShaderEditor.GrabScreenPosition;11;-863.0537,161.3339;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-858.8156,449.8164;Inherit;False;Property;_NormalFactor;NormalFactor;6;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;26;-1068.769,669.3733;Inherit;False;1140.09;528.6523;Voronoi Noise as a heightMap with a scale factor in the Y axis;7;25;24;23;22;21;20;19;Voronoi Height Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;16;-544.3137,390.0791;Inherit;True;Property;_Normals;Normals;7;0;Create;True;0;0;0;False;0;False;-1;302951faffe230848aa0d3df7bb70faa;302951faffe230848aa0d3df7bb70faa;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-1048.438,726.1368;Inherit;False;Property;_TimeFactor2;Time Factor;10;0;Create;False;0;0;0;False;0;False;2;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-517.6929,132.7997;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-738.9301,731.1013;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-231.7744,224.4951;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-839.6982,840.0091;Inherit;False;Property;_VoronoiScale2;Voronoi Scale;9;0;Create;False;0;0;0;False;0;False;5;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;13;-76.76526,101.4638;Inherit;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;24;-537.2855,725.7536;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector3Node;22;-343.8303,955.1804;Inherit;False;Constant;_VectorUP;Vector UP;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;15;-547.9285,-105.5856;Inherit;False;Property;_WaterColor;WaterColor;5;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-449.4434,1114.977;Inherit;False;Property;_HeightFactor2;Height Factor;8;0;Create;False;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-96.21819,723.7077;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;43.08429,-52.61623;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;475.526,-18.26435;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;7_DepthFade;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;5;17;0
WireConnection;12;0;11;1
WireConnection;12;1;11;2
WireConnection;20;0;19;0
WireConnection;18;0;12;0
WireConnection;18;1;16;0
WireConnection;13;0;18;0
WireConnection;24;1;20;0
WireConnection;24;2;21;0
WireConnection;25;0;24;0
WireConnection;25;1;22;0
WireConnection;25;2;23;0
WireConnection;14;0;15;0
WireConnection;14;1;13;0
WireConnection;0;0;14;0
WireConnection;0;11;25;0
ASEEND*/
//CHKSM=87B5F266DB59C3612046F231D83E9143EB581898