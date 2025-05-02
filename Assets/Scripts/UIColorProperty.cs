using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class UIColorProperty : MonoBehaviour
{
    [SerializeField]
    TextMeshProUGUI displayName;

    [SerializeField]
    TMP_InputField red;

    [SerializeField]
    TMP_InputField green;

    [SerializeField]
    TMP_InputField blue;

    public ShaderColorProperty shaderColorProperty;
    public AmplifyShaderController targetShaderController;

    public void SetUiColorProperty(ShaderColorProperty shaderColorProperty, AmplifyShaderController targetShaderController)
    {
        this.shaderColorProperty = shaderColorProperty;
        this.targetShaderController = targetShaderController;

        displayName.text = shaderColorProperty.displayName;

        red.onValueChanged.AddListener(UpdateRed);
        green.onValueChanged.AddListener(UpdateGreen);
        blue.onValueChanged.AddListener(UpdateBlue);

        red.text = Mathf.RoundToInt(shaderColorProperty.defaultColor.r * 255).ToString();
        green.text = Mathf.RoundToInt(shaderColorProperty.defaultColor.g * 255).ToString();
        blue.text = Mathf.RoundToInt(shaderColorProperty.defaultColor.b * 255).ToString();

        UpdateRed(red.text);
        UpdateGreen(green.text);
        UpdateBlue(blue.text);
    }

    void UpdateRed(string value)
    {
        red.text = Mathf.Clamp(int.Parse(value), 0, 255).ToString();
        UpdateColor();
    }

    void UpdateGreen(string value)
    {
        green.text = Mathf.Clamp(int.Parse(value), 0, 255).ToString();
        UpdateColor();
    }

    void UpdateBlue(string value)
    {
        blue.text = Mathf.Clamp(int.Parse(value), 0, 255).ToString();
        UpdateColor();
    }

    Color NormalizedColor(string r, string g, string b)
    {
        return new Color
        (
            (string.IsNullOrEmpty(r) ? 0 : int.Parse(r)) / 255f,
            (string.IsNullOrEmpty(g) ? 0 : int.Parse(g)) / 255f,
            (string.IsNullOrEmpty(b) ? 0 : int.Parse(b)) / 255f,
            1
        );
    }

    void UpdateColor()
    {
        Color color = NormalizedColor(red.text, green.text, blue.text);
        targetShaderController.UpdateColorPropertyValue(shaderColorProperty.propertyName, color);
    }

    private void OnDestroy()
    {
        red.onValueChanged.RemoveListener(UpdateRed);
        green.onValueChanged.RemoveListener(UpdateGreen);
        blue.onValueChanged.RemoveListener(UpdateBlue);
    }
}
