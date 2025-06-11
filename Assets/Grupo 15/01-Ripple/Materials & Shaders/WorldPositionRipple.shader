// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WorldPositionRipple"
{
	Properties
	{
		_TopColor1("TopColor", Color) = (0.6562443,0,1,1)
		_BottomColor1("BottomColor", Color) = (1,0,0,1)
		_Height1("Height", Range( 0 , 10)) = 1
		_Epicenter1("Epicenter", Vector) = (-10,0,-6.51,0)
		_Frequency1("Frequency", Range( 0 , 10)) = 1
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

		uniform float3 _Epicenter1;
		uniform float _Frequency1;
		uniform float _Height1;
		uniform float4 _TopColor1;
		uniform float4 _BottomColor1;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_11_0 = (0.0 + (sin( ( ( distance( ase_worldPos , _Epicenter1 ) + _Time.y ) * _Frequency1 ) ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float3 temp_output_16_0 = ( temp_output_11_0 * float3(0,1,0) * _Height1 );
			v.vertex.xyz += temp_output_16_0;
			v.vertex.w = 1;
			v.normal = temp_output_16_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float temp_output_11_0 = (0.0 + (sin( ( ( distance( ase_worldPos , _Epicenter1 ) + _Time.y ) * _Frequency1 ) ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float4 lerpResult15 = lerp( _TopColor1 , _BottomColor1 , temp_output_11_0);
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
0;598;1592;393;1889.66;461.165;1.3;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;18;-1943.853,-74.31325;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;1;-1877.645,159.8074;Inherit;False;Property;_Epicenter1;Epicenter;3;0;Create;True;0;0;0;False;0;False;-10,0,-6.51;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;3;-1643.032,130.8186;Inherit;False;Constant;_TimeScale1;TimeScale;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-1481.738,134.9023;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;5;-1640.42,-3.595754;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1475.91,228.216;Inherit;False;Property;_Frequency1;Frequency;4;0;Create;True;0;0;0;False;0;False;1;3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1267.421,-2.850163;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1117.187,-1.396459;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;9;-893.364,68.55;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-673.587,-154.3889;Inherit;False;Property;_BottomColor1;BottomColor;1;0;Create;True;0;0;0;False;0;False;1,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;12;-686.8821,255.2225;Inherit;False;Constant;_DeformationVector1;DeformationVector;0;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;11;-656.3417,63.57276;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-743.535,403.5933;Inherit;False;Property;_Height1;Height;2;0;Create;True;0;0;0;False;0;False;1;0.14;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-672.4581,-356.8507;Inherit;False;Property;_TopColor1;TopColor;0;0;Create;True;0;0;0;False;0;False;0.6562443,0,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.EdgeLengthTessNode;17;-489.2677,517.5228;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;15;-408.1922,-35.93797;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-412.5705,94.9157;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;WorldPositionRipple;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;3;0
WireConnection;5;0;18;0
WireConnection;5;1;1;0
WireConnection;7;0;5;0
WireConnection;7;1;4;0
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;9;0;8;0
WireConnection;11;0;9;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;15;2;11;0
WireConnection;16;0;11;0
WireConnection;16;1;12;0
WireConnection;16;2;10;0
WireConnection;0;0;15;0
WireConnection;0;11;16;0
WireConnection;0;12;16;0
WireConnection;0;14;17;0
ASEEND*/
//CHKSM=25B32B8105A25ED13ACC334DEA618AA22D0B2958