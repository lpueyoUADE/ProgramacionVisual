using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UISliderColorProperty : MonoBehaviour
{
    [SerializeField]
    TextMeshProUGUI displayName;

    [Header("Text Values")]
    [SerializeField] TextMeshProUGUI redText;
    [SerializeField] TextMeshProUGUI greenText;
    [SerializeField] TextMeshProUGUI blueText;

    [Header("Sliders")]
    [SerializeField] Slider redSlider;
    [SerializeField] Slider greenSlider;
    [SerializeField] Slider blueSlider;

    [Header("Result")]
    [SerializeField] Image resultImage;

    public ShaderColorProperty shaderColorProperty;
    public AmplifyShaderController targetShaderController;

    public void SetUiColorProperty(ShaderColorProperty shaderColorProperty, AmplifyShaderController targetShaderController)
    {
        this.shaderColorProperty = shaderColorProperty;
        this.targetShaderController = targetShaderController;

        displayName.text = shaderColorProperty.displayName;

        redSlider.onValueChanged.AddListener(UpdateRed);
        greenSlider.onValueChanged.AddListener(UpdateGreen);
        blueSlider.onValueChanged.AddListener(UpdateBlue);

        int r = Mathf.RoundToInt(shaderColorProperty.defaultColor.r * 255);
        int g = Mathf.RoundToInt(shaderColorProperty.defaultColor.g * 255);
        int b = Mathf.RoundToInt(shaderColorProperty.defaultColor.b * 255);

        redText.text = r.ToString();
        greenText.text = g.ToString();
        blueText.text = b.ToString();

        redSlider.value = r;
        greenSlider.value = g;
        blueSlider.value = b;

        UpdateRed(redSlider.value);
        UpdateGreen(greenSlider.value);
        UpdateBlue(blueSlider.value);
    }

    void UpdateRed(float value)
    {
        int newValue = ((int)Mathf.Clamp(value, 0, 255));
        redText.text = newValue.ToString();
        redSlider.value = newValue;
        UpdateColor();
    }

    void UpdateGreen(float value)
    {
        int newValue = ((int)Mathf.Clamp(value, 0, 255));
        greenText.text = newValue.ToString();
        greenSlider.value = newValue;
        UpdateColor();
    }

    void UpdateBlue(float value)
    {
        int newValue = ((int)Mathf.Clamp(value, 0, 255));
        blueText.text = newValue.ToString();
        blueSlider.value = newValue;
        UpdateColor();
    }

    Color NormalizedColor(float r, float g, float b)
    {
        return new Color
        (
            (int)r / 255f,
            (int)g / 255f,
            (int)b / 255f,
            1
        );
    }

    void UpdateColor()
    {
        Color color = NormalizedColor(redSlider.value, greenSlider.value, blueSlider.value);
        targetShaderController.UpdateColorPropertyValue(shaderColorProperty.propertyName, color);
        resultImage.color = color;
    }

    private void OnDestroy()
    {
        redSlider.onValueChanged.RemoveListener(UpdateRed);
        greenSlider.onValueChanged.RemoveListener(UpdateGreen);
        blueSlider.onValueChanged.RemoveListener(UpdateBlue);
    }
}
