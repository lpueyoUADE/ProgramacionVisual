using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AmplifyShaderController : MonoBehaviour
{
    public Renderer meshRenderer;
    public Material instancedMaterial;

    [SerializeField]
    private List<ShaderProperty> shaderProperties;

    [SerializeField]
    private List<ShaderColorProperty> shaderColorProperties;

    public List<ShaderProperty> ShaderProperties { get => shaderProperties; }
    public List<ShaderColorProperty> ShaderColorProperties { get => shaderColorProperties; }

    protected virtual void Awake()
    {
        meshRenderer = GetComponent<Renderer>();
        instancedMaterial = meshRenderer.material;
    }

    public void UpdatePropertyValue(string propertyName, float value)
    {
        instancedMaterial.SetFloat(propertyName, value);
    }

    public void UpdateColorPropertyValue(string propertyName, Color color)
    {
        instancedMaterial.SetColor(propertyName, color);
    }
}
