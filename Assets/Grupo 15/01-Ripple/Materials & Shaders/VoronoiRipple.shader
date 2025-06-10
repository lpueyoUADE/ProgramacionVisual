// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VoronoiRipple"
{
	Properties
	{
		_VoronoiScale2("Voronoi Scale", Range( 0 , 10)) = 2
		_TimeFactor2("Time Factor", Range( 0 , 10)) = 1
		_TopColor1("TopColor", Color) = (1,1,1,0)
		_BottomColor1("BottomColor", Color) = (0,0,0,0)
		_Height1("Height", Range( 0 , 10)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _VoronoiScale2;
		uniform float _TimeFactor2;
		uniform float _Height1;
		uniform float4 _TopColor1;
		uniform float4 _BottomColor1;


		float2 voronoihash19( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi19( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -2; j <= 2; j++ )
			{
				for ( int i = -2; i <= 2; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash19( n + g );
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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime18 = _Time.y * _TimeFactor2;
			float time19 = mulTime18;
			float2 coords19 = v.texcoord.xy * _VoronoiScale2;
			float2 id19 = 0;
			float2 uv19 = 0;
			float voroi19 = voronoi19( coords19, time19, id19, uv19, 0 );
			float clampResult26 = clamp( ( voroi19 * 2.0 ) , 0.0 , 1.0 );
			float3 temp_output_20_0 = ( clampResult26 * float3(0,1,0) * _Height1 );
			v.vertex.xyz += temp_output_20_0;
			v.vertex.w = 1;
			v.normal = temp_output_20_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime18 = _Time.y * _TimeFactor2;
			float time19 = mulTime18;
			float2 coords19 = i.uv_texcoord * _VoronoiScale2;
			float2 id19 = 0;
			float2 uv19 = 0;
			float voroi19 = voronoi19( coords19, time19, id19, uv19, 0 );
			float clampResult26 = clamp( ( voroi19 * 2.0 ) , 0.0 , 1.0 );
			float4 lerpResult15 = lerp( _TopColor1 , _BottomColor1 , clampResult26);
			o.Albedo = lerpResult15.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;598;1592;393;2027.017;58.51334;1.32576;True;False
Node;AmplifyShaderEditor.RangedFloatNode;17;-1663.15,-63.61806;Inherit;False;Property;_TimeFactor2;Time Factor;1;0;Create;True;0;0;0;False;0;False;1;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;18;-1353.642,-58.65365;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1454.41,50.25403;Inherit;False;Property;_VoronoiScale2;Voronoi Scale;0;0;Create;True;0;0;0;False;0;False;2;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;19;-1149.305,-64.00137;Inherit;True;1;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-959.629,-75.98548;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;26;-750.592,-75.49387;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;10;-541.1995,162.0345;Inherit;False;Constant;_DeformationVector1;DeformationVector;0;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;14;-526.7756,-450.0388;Inherit;False;Property;_TopColor1;TopColor;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-525.3612,-257.7498;Inherit;False;Property;_BottomColor1;BottomColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-597.8525,310.4052;Inherit;False;Property;_Height1;Height;4;0;Create;True;0;0;0;False;0;False;1;0.14;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;15;-262.5098,-129.126;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-266.8881,1.727673;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;21;-343.5853,424.3349;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;VoronoiRipple;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;17;0
WireConnection;19;1;18;0
WireConnection;19;2;16;0
WireConnection;22;0;19;0
WireConnection;26;0;22;0
WireConnection;15;0;14;0
WireConnection;15;1;12;0
WireConnection;15;2;26;0
WireConnection;20;0;26;0
WireConnection;20;1;10;0
WireConnection;20;2;13;0
WireConnection;0;0;15;0
WireConnection;0;11;20;0
WireConnection;0;12;20;0
WireConnection;0;14;21;0
ASEEND*/
//CHKSM=CB595B0D45B6218B06E8A935CB08E35ACC486687