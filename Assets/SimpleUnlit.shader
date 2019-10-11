Shader "Unlit/SimpleUnlit"{
    Properties{
        //_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader{
        Tags { "RenderType"="Opaque" }

        Pass{
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            //Mesh data, vertext position, vertex normal, uvs, tangents, vertex colors
            struct VertexInput {
                float4 vertex : POSITION;
                float2 uv0: TEXCOORD0;
                float3 normal: NORMAL;

                // float2 uv1: TEXCORD1;
                // float4 colors: COLOR;
                float4 tangents: TANGENT;
            };

            struct VertexOutput{
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal: NORMAL;
                float4 tangents: TANGENT;
            };

            //sampler2D _MainTex;
            //float4 _MainTex_ST;

            VertexOutput vert (VertexInput v){
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normal = v.normal;
                o.tangents = v.tangents;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target{
                float2 uv = i.uv0;
                // normals range from -1 to 1, we want 0 to 1,
                float3 normals = i.normal * 0.5 + 0.5; 
                //float3 tangents = i.tangents;
                return float4(tangents, 0);
            }
            ENDCG
        }
    }
}
