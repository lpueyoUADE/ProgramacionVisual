// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "1_heightMapShader"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_HeightFactor("Height Factor", Range( 0 , 10)) = 0
		_VoronoiScale("Voronoi Scale", Range( 0 , 10)) = 5
		_TimeFactor("Time Factor", Range( 0 , 10)) = 1
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

		uniform float _VoronoiScale;
		uniform float _TimeFactor;
		uniform float _HeightFactor;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;


		float2 voronoihash39( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi39( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash39( n + g );
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
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, 1.0,10.0,5.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime49 = _Time.y * _TimeFactor;
			float time39 = mulTime49;
			float2 coords39 = v.texcoord.xy * _VoronoiScale;
			float2 id39 = 0;
			float2 uv39 = 0;
			float voroi39 = voronoi39( coords39, time39, id39, uv39, 0 );
			v.vertex.xyz += ( voroi39 * float3(0,1,0) * _HeightFactor );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;598;1592;393;3341.05;482.4117;2.934989;True;False
Node;AmplifyShaderEditor.CommentaryNode;12;-1869.602,-88.22954;Inherit;False;1140.09;528.6523;Voronoi Noise as a heightMap with a scale factor in the Y axis;7;8;39;4;3;51;49;53;Voronoi Height Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1849.271,-31.46602;Inherit;False;Property;_TimeFactor;Time Factor;3;0;Create;True;0;0;0;False;0;False;1;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;49;-1539.763,-26.50155;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1640.531,82.40628;Inherit;False;Property;_VoronoiScale;Voronoi Scale;2;0;Create;True;0;0;0;False;0;False;5;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-629.5952,227.2347;Inherit;False;Constant;_min;min;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-630.0837,141.742;Inherit;False;Constant;_Factor;Factor;1;0;Create;True;0;0;0;False;0;False;5;0;1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-633.6774,315.9074;Inherit;False;Constant;_max;max;1;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;3;-1144.663,197.5775;Inherit;False;Constant;_VectorUP;Vector UP;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-1250.276,357.3745;Inherit;False;Property;_HeightFactor;Height Factor;1;0;Create;True;0;0;0;False;0;False;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;39;-1338.118,-31.84927;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SamplerNode;10;-365.6747,-424.6793;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;f7e96904e8667e1439548f0f86389447;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceBasedTessNode;9;-340.5876,139.1253;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-897.0507,-33.89513;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;42.49977,-362.6646;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;1_heightMapShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;11;-682.0837,83.74211;Inherit;False;609.9865;352.3257;Subvidide mesh by distance;0;Tesselation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;13;-415.6747,-474.6792;Inherit;False;367.7;280;Main Texture;0;Albedo;1,1,1,1;0;0
WireConnection;49;0;53;0
WireConnection;39;1;49;0
WireConnection;39;2;51;0
WireConnection;9;0;5;0
WireConnection;9;1;6;0
WireConnection;9;2;7;0
WireConnection;8;0;39;0
WireConnection;8;1;3;0
WireConnection;8;2;4;0
WireConnection;0;0;10;0
WireConnection;0;11;8;0
WireConnection;0;14;9;0
ASEEND*/
//CHKSM=3E1CAAEC1C8AE6799A205D13C017CA638B870081