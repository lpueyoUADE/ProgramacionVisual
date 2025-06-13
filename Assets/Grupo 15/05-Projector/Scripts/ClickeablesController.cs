using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClickeablesController : MonoBehaviour
{
    private Clickable[] clickables;
    private Clickable currentSelected;

    void Start()
    {
        clickables = FindObjectsByType<Clickable>(FindObjectsSortMode.None);

        foreach (var clickable in clickables)
        {
            clickable.OnClicked += HandleObjectClicked;
        }
    }

    void HandleObjectClicked(Clickable clicked)
    {
        if (currentSelected != null && currentSelected != clicked)
        {
            currentSelected.SetSelected(false);
        }

        currentSelected = clicked;
        currentSelected.SetSelected(!currentSelected.IsSelected);
    }

    private void OnDestroy()
    {
        foreach (var clickable in clickables)
        {
            clickable.OnClicked -= HandleObjectClicked;
        }
    }
}
