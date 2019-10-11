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
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            //Mesh data, vertext position, vertex normal, uvs, tangents, vertex colors
            struct VertexInput {
                float4 vertex : POSITION;
                float2 uv0: TEXCOORD0;
                float3 normal: NORMAL;

                // float2 uv1: TEXCORD1;
                // float4 colors: COLOR;
                //float4 tangents: TANGENT;
            };

            struct VertexOutput{
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal: NORMAL;
                //float4 tangents: TANGENT;
            };

            //sampler2D _MainTex;
            //float4 _MainTex_ST;

            VertexOutput vert (VertexInput v){
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normal = v.normal;
                //o.tangents = v.tangents;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target{
                float2 uv = i.uv0;
                // normals range from -1 to 1, we want 0 to 1,
                //float3 normals = i.normal * 0.5+0.5; 
                //float3 normals = i.normal;
                //return float4(normals, 0);
                
                //working with lights
                // float3 lightDir = normalize(float3(1,1,1));
                // float intensity = dot(lightDir, i.normal);
                // float3 color = i.normal * intensity + 0.5;

                // //v2
                // float3 lightDir = normalize(float3(1,1,1));
                // float intensity = dot(lightDir, i.normal);
                // float3 lightColor = float3(1, 0.8, 0.78);
                
                // //v3
                // float3 lightDir = normalize(float3(1,1,1));
                // //saturate :WORST NAME: actually clamp 0-1
                // float intensity = saturate(dot(lightDir, i.normal));
                // float3 lightColor = float3(1, 0.8, 0.78);
                // float3 diffuseLight = lightColor * intensity;
                // float3 ambientLight = float3(0.2, 0.2, 0.5);

                //v4
                //float3 lightDir = normalize(float3(1,1,1));
                float3 lightDir = _WorldSpaceLightPos0;
                float3 lightColor = _LightColor0.rgb;

                //saturate :WORST NAME: actually clamp 0-1
                float intensity = saturate(dot(lightDir, i.normal));
                
                float3 diffuseLight = lightColor * intensity;
                float3 ambientLight = float3(0.2, 0.2, 0.5);

                return float4(ambientLight + diffuseLight, 0);
                
            }
            ENDCG
        }
    }
}
