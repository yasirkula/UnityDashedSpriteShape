Shader "Sprites/Dashed Sprite Shape"
{
	Properties
	{
		[PerRendererData] _MainTex( "Sprite", 2D ) = "white" {}
		[PerRendererData] _RendererColor( "Color", Color ) = ( 1, 1, 1, 1 )
		_Tiling( "Tiling", Int ) = 1
		_Thickness( "Thickness", Range( 0.0, 1.0 ) ) = 1.0
		_ScrollSpeed( "Scroll Speed", Float ) = 1.0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector" = "True" "PreviewType" = "Plane" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
		Lighting Off
		ZWrite Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			float _Tiling;
			float _Thickness;
			float _ScrollSpeed;
			fixed4 _RendererColor;

			v2f vert( appdata v )
			{
				v2f o;
				o.vertex = UnityObjectToClipPos( v.vertex );
				o.uv = float2( v.uv.x * _Tiling + _ScrollSpeed * _Time.x, 0.5f + ( 0.5 - v.uv.y ) * ( 1.0 - _Thickness ) );
				return o;
			}

			fixed4 frag( v2f i ) : SV_Target
			{
				fixed4 col = tex2D( _MainTex, i.uv ) * _RendererColor;
				return col;
			}
			ENDCG
		}
	}
}