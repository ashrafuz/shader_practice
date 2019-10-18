Shader "Unlit/SimpleUnlit2"{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
        _Gloss ("Gloss", Float) = 1
        _IslandTex ("Texture", 2D) = "black" {}
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
                float3 worldPos: TEXCOORD1;
                //float4 tangents: TANGENT;
            };

            sampler2D _IslandTex;
            //float4 _MainTex_ST;
            float4 _Color;
            float _Gloss;
            uniform float3 _MousePos;

            VertexOutput vert (VertexInput v){
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float InvLerp(float a, float b, float val){
                return (val - a) / (b-a);
            }

            float3 MyLerp (float3 a, float3 b, float t){
                return t*b + (1-t)*a;
            }

            float Posterize(float steps, float value){
                return floor(steps*value) / steps;
            }

            fixed4 frag (VertexOutput i) : SV_Target{
                float _island = tex2D(_IslandTex, i.uv0).x;
                float timeFactor = frac(_Time.y); //frac = value - floor(value);
                //float shape = i.uv0.y;
                float shape = _island;

                float waveSize = 0.04;
                float waveAmp = (sin(shape / waveSize + _Time.y) + 1) * 0.5;
                float waveValues = waveAmp * _island;

                return waveValues;


                float dist = distance(_MousePos, i.worldPos);
                return 1-dist;

                float2 uv = i.uv0;
                float3 normal = normalize(i.normal); //interpolated

                float3 c1 = float3(0.1, 0.8, 0.4);
                float3 c2 = float3(0.9, 0.1,0.2);
                float t = uv.y;

                float3 blend = MyLerp(c1, c2, uv.y); // uv.y => 0 to 1
                //float3 blend = InvLerp(0.25, 0.75, uv.y);
                //return float4(blend, 0);
                //return Posterize( 10, uv.y); // STEPPING

                //v4
                //Direct light
                float3 lightDir = _WorldSpaceLightPos0;
                float3 lightColor = _LightColor0.rgb;
                //clamping 0 - 1
                float intensity = max(0, dot(lightDir, normal));
                float3 diffuseLight = lightColor * intensity;

                //Ambient Light
                float3 ambientLight = float3(0.2, 0.2, 0.5);

                //Direct Specular Light
                float3 cameraPos = _WorldSpaceCameraPos;
                float3 fragToCamera = cameraPos - i.worldPos;
                float3 viewDirection = normalize(fragToCamera);
                //return float4(viewDirection, 1);
                //Phong 
                float3 viewReflection = reflect( -viewDirection, normal );
                //return float4(viewReflection, 1);
                float specularFalloff = max(0,dot(viewReflection, lightDir)) ;
                specularFalloff = Posterize(10, specularFalloff);
                
                //modify with gloss (how shiny do you want the object to be)
                specularFalloff = pow(specularFalloff, _Gloss);

                float3 directSpecular = specularFalloff * lightColor;
                // return float4(directSpecular, 1);

                //Composite Light
                float3 totalDiffuseLights = ambientLight + diffuseLight;
                float3 finalSurfaceColor = totalDiffuseLights * _Color.rgb + directSpecular;
                // float3 ;

                return float4(finalSurfaceColor, 0);
                
            }
            ENDCG
        }
    }
}
