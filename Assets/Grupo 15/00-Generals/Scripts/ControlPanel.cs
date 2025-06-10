using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlPanel : MonoBehaviour
{

    [SerializeField]
    GameObject UiPropertyPrefab;

    [SerializeField]
    GameObject UiColorPropertyPrefab;

    AmplifyShaderController[] targetShaderControllers;

    private void Start()
    {
        var targetShaderControllers = FindObjectsByType<AmplifyShaderController>(FindObjectsSortMode.None);

        if (targetShaderControllers.Length == 0)
            return;

        foreach (var shaderController in targetShaderControllers)
        {
            foreach (var property in shaderController.ShaderProperties)
            {
                GameObject newProperty = Instantiate(UiPropertyPrefab, transform);
                UIProperty newUIProperty = newProperty.GetComponent<UIProperty>();

                newUIProperty.SetUiProperty(property, shaderController);
            }

            foreach (var colorProperty in shaderController.ShaderColorProperties)
            {
                GameObject newColorProperty = Instantiate(UiColorPropertyPrefab, transform);
                UISliderColorProperty newUIColorProperty = newColorProperty.GetComponent<UISliderColorProperty>();

                newUIColorProperty.SetUiColorProperty(colorProperty, shaderController);
            }
        }
    }
}
