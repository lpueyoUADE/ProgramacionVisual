using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Clickable : MonoBehaviour
{
    [SerializeField]
    Projector projector;

    [SerializeField]
    Light headLight;

    public event Action<Clickable> OnClicked;
    public bool IsSelected { get; private set; }

    public void SetSelected(bool selected)
    {
        IsSelected = selected;
        projector.enabled = selected;
        headLight.enabled = selected;
    }

    void OnMouseDown()
    {
        OnClicked?.Invoke(this);
    }
}
