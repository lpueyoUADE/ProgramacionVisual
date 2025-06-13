using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectorAmplifyShaderController : AmplifyShaderController
{
    protected override void Awake()
    {
        instancedMaterial = GetComponent<Projector>().material;
    }
}
