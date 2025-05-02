using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlPanel : MonoBehaviour
{
    [SerializeField]
    AmplifyShaderController targetShaderController;

    [SerializeField]
    GameObject UiPropertyPrefab;

    [SerializeField]
    GameObject UiColorPropertyPrefab;

    private void Start()
    {
        if(targetShaderController == null)
            return;

        foreach (var property in targetShaderController.ShaderProperties)
        {
            GameObject newProperty = Instantiate(UiPropertyPrefab, transform);
            UIProperty newUIProperty = newProperty.GetComponent<UIProperty>();

            newUIProperty.SetUiProperty(property, targetShaderController);
        }

        foreach (var colorProperty in targetShaderController.ShaderColorProperties)
        {
            GameObject newColorProperty = Instantiate(UiColorPropertyPrefab, transform);
            UIColorProperty newUIColorProperty = newColorProperty.GetComponent<UIColorProperty>();

            newUIColorProperty.SetUiColorProperty(colorProperty, targetShaderController);
        }
    }
}
