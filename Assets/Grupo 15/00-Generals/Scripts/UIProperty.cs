using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UIProperty : MonoBehaviour
{
    [SerializeField]
    TextMeshProUGUI displayName;

    [Header("Slider")]

    [SerializeField] Slider slider;
    [SerializeField]
    TextMeshProUGUI minSliderValue;

    [SerializeField]
    TextMeshProUGUI maxSliderValue;
    
    [SerializeField]
    TextMeshProUGUI currentSliderValue;

    public ShaderProperty shaderProperty;
    public AmplifyShaderController targetShaderController;

    public void SetUiProperty(ShaderProperty shaderProperty, AmplifyShaderController targetShaderController)
    {
        this.shaderProperty = shaderProperty;
        this.targetShaderController = targetShaderController;
        
        slider.minValue = shaderProperty.minValue;
        slider.maxValue = shaderProperty.maxValue;
        slider.value = shaderProperty.defaultValue;

        slider.onValueChanged.AddListener(UpdateTargetProperty);

        displayName.text = shaderProperty.displayName;
        minSliderValue.text = shaderProperty.minValue.ToString();
        maxSliderValue.text = shaderProperty.maxValue.ToString();
        currentSliderValue.text = shaderProperty.defaultValue.ToString();

        UpdateTargetProperty(shaderProperty.defaultValue);
    }
    void UpdateTargetProperty(float value)
    {
        targetShaderController.UpdatePropertyValue(shaderProperty.propertyName, value);
        currentSliderValue.text = value.ToString("F2");
    }

    private void OnDestroy()
    {
        slider.onValueChanged.RemoveListener(UpdateTargetProperty);
    }
}
