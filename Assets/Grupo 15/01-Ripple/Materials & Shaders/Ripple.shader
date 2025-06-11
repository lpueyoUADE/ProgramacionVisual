// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ripple"
{
	Properties
	{
		_TopColor("TopColor", Color) = (1,1,1,0)
		_BottomColor("BottomColor", Color) = (0,0,0,0)
		_Height("Height", Range( 0 , 10)) = 1
		_Epicenter("Epicenter", Vector) = (0,0,0,0)
		_Frequency("Frequency", Range( 0 , 10)) = 1
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
			float3 worldPos;
		};

		uniform float3 _Epicenter;
		uniform float _Frequency;
		uniform float _Height;
		uniform float4 _TopColor;
		uniform float4 _BottomColor;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_19_0 = (0.0 + (sin( ( ( distance( ase_vertex3Pos , _Epicenter ) + _Time.y ) * _Frequency ) ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float3 temp_output_21_0 = ( temp_output_19_0 * float3(0,1,0) * _Height );
			v.vertex.xyz += temp_output_21_0;
			v.vertex.w = 1;
			v.normal = temp_output_21_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_19_0 = (0.0 + (sin( ( ( distance( ase_vertex3Pos , _Epicenter ) + _Time.y ) * _Frequency ) ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float4 lerpResult28 = lerp( _TopColor , _BottomColor , temp_output_19_0);
			o.Albedo = lerpResult28.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;598;1592;393;4811.058;1003.631;4.617802;True;False
Node;AmplifyShaderEditor.Vector3Node;11;-2186.328,6.541478;Inherit;False;Property;_Epicenter;Epicenter;3;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;29;-2198.394,-157.9953;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1951.715,-22.44728;Inherit;False;Constant;_TimeScale;TimeScale;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-1790.421,-18.36365;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;12;-1949.103,-156.8617;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1784.593,74.95011;Inherit;False;Property;_Frequency;Frequency;4;0;Create;True;0;0;0;False;0;False;1;3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1576.104,-156.1161;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1425.87,-154.6624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;18;-1202.047,-84.71596;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1052.218,250.3273;Inherit;False;Property;_Height;Height;2;0;Create;True;0;0;0;False;0;False;1;0.14;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;19;-965.0247,-89.69319;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;23;-995.5651,101.9566;Inherit;False;Constant;_DeformationVector;DeformationVector;0;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;26;-981.1411,-510.1167;Inherit;False;Property;_TopColor;TopColor;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;-982.27,-307.6548;Inherit;False;Property;_BottomColor;BottomColor;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;28;-716.8752,-189.2039;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-721.2535,-58.35024;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;43;-797.9507,364.257;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-487.7522,-206.4228;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Ripple;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;15;25;50;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;15;0
WireConnection;12;0;29;0
WireConnection;12;1;11;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;16;0;13;0
WireConnection;16;1;17;0
WireConnection;18;0;16;0
WireConnection;19;0;18;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;28;2;19;0
WireConnection;21;0;19;0
WireConnection;21;1;23;0
WireConnection;21;2;24;0
WireConnection;0;0;28;0
WireConnection;0;11;21;0
WireConnection;0;12;21;0
WireConnection;0;14;43;0
ASEEND*/
//CHKSM=04907D4A13E425D7A6BB86951E5DE5FB38B0780B