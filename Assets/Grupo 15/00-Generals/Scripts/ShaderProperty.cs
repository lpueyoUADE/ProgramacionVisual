using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ShaderProperty
{
    public string propertyName;
    public string displayName;
    public float minValue=0;
    public float maxValue=1;
    public float defaultValue=0;
    public bool wholeNumbers = false;
}
