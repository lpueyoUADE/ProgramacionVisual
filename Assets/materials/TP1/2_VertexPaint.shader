// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "2_VertexPaint"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 15
		_Grass("Grass", 2D) = "white" {}
		_HeightFactor("HeightFactor", Float) = 2
		_Dirt("Dirt", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float _HeightFactor;
		uniform sampler2D _Grass;
		uniform float4 _Grass_ST;
		uniform sampler2D _Dirt;
		uniform float4 _Dirt_ST;
		uniform float _TessValue;

		float4 tessFunction( )
		{
			return _TessValue;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float Red11 = v.color.r;
			v.vertex.xyz += ( _HeightFactor * float3(0,1,0) * Red11 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float Green12 = i.vertexColor.g;
			float2 uv_Grass = i.uv_texcoord * _Grass_ST.xy + _Grass_ST.zw;
			float Blue13 = i.vertexColor.b;
			float2 uv_Dirt = i.uv_texcoord * _Dirt_ST.xy + _Dirt_ST.zw;
			o.Albedo = ( ( Green12 * tex2D( _Grass, uv_Grass ) ) + ( Blue13 * tex2D( _Dirt, uv_Dirt ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;588;1515;403;4100.761;741.7459;4.292841;True;False
Node;AmplifyShaderEditor.CommentaryNode;17;-1189.951,-123.6159;Inherit;False;489.8251;357.977;Comment;4;2;13;11;12;Vertex Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;2;-1139.951,-45.06219;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-939.5258,21.81981;Inherit;False;Green;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-940.9692,119.2012;Inherit;False;Blue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;-617.1517,-570.2813;Inherit;False;544.306;362.8895;Comment;3;15;6;8;Grass - Green;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;20;-621.4332,-144.7202;Inherit;False;534.2511;378.0713;Comment;3;14;7;10;Dirt - Blue;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;6;-567.1516,-437.3918;Inherit;True;Property;_Grass;Grass;5;0;Create;True;0;0;0;False;0;False;-1;c68296334e691ed45b62266cbc716628;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-571.4332,3.351074;Inherit;True;Property;_Dirt;Dirt;7;0;Create;True;0;0;0;False;0;False;-1;ceb1bacd3e5dc9b4cb4b85eb1a74cfb6;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;15;-461.9939,-520.2813;Inherit;False;12;Green;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;18;-506.888,343.181;Inherit;False;430.2925;407.2466;Comment;4;5;4;16;3;Height - Red;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-942.579,-73.61587;Inherit;False;Red;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-463.1012,-91.41098;Inherit;False;13;Blue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-240.3858,-516.9404;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-449.6308,393.181;Inherit;False;Property;_HeightFactor;HeightFactor;6;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-254.722,-94.72018;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-456.888,635.2676;Inherit;False;11;Red;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;4;-438.3283,478.34;Inherit;False;Constant;_Axis;Axis;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-244.1356,399.8534;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;143.1226,-344.5161;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;365.7503,-341.1895;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;2_VertexPaint;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;2;2
WireConnection;13;0;2;3
WireConnection;11;0;2;1
WireConnection;8;0;15;0
WireConnection;8;1;6;0
WireConnection;10;0;14;0
WireConnection;10;1;7;0
WireConnection;3;0;5;0
WireConnection;3;1;4;0
WireConnection;3;2;16;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;0;0;9;0
WireConnection;0;11;3;0
ASEEND*/
//CHKSM=74A0AA781ABE1FCB0D306F54DE83F84D2FC1DAAD