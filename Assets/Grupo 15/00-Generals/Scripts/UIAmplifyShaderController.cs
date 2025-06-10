using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class UIAmplifyShaderController : AmplifyShaderController
{
    public Image image;
    protected override void Awake()
    {
        image = GetComponent<Image>();
        Material copy = new Material(image.material);
        image.material = copy;
        instancedMaterial = copy;
    }
}