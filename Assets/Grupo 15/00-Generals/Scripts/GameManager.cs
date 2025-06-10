using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    [Header("UI")]
    [SerializeField]
    GameObject controlPanel;

    [SerializeField]
    GameObject selectorMenu;

    [SerializeField]
    TextMeshProUGUI ToggleFreeflyText;

    [Header("Free Fly Character")]
    [SerializeField]
    BasicFirstPersonController freeFlyCharacter;

    [Header("Settings")]
    [SerializeField]
    bool useSelectorMenu = false;

    [SerializeField]
    bool useFreeFlyCharacter = false;

    bool isSelectorMenuOpen = false;
    bool isFreeFlyCharacterActive = false;

    Camera mainCamera;
    Camera freeFlyCamera;

    private void Start()
    {
        mainCamera = Camera.main;
        freeFlyCamera = freeFlyCharacter.freeFlyCamera;

        SetSelectorMenuVisibilty(false);
        SetFreeFlyCharacterState(false);

        ToggleFreeflyText.gameObject.SetActive(useFreeFlyCharacter);
    }

    void Update()
    {
        if (!useSelectorMenu && Input.GetKeyDown(KeyCode.Keypad1)) SceneManager.LoadScene(0);
        if (!useSelectorMenu && Input.GetKeyDown(KeyCode.Keypad2)) SceneManager.LoadScene(1);
        if (!useSelectorMenu && Input.GetKeyDown(KeyCode.Keypad3)) SceneManager.LoadScene(2);
        if (!useSelectorMenu && Input.GetKeyDown(KeyCode.Keypad4)) SceneManager.LoadScene(3);
        if (!useSelectorMenu && Input.GetKeyDown(KeyCode.Keypad5)) SceneManager.LoadScene(4);
        if (!useSelectorMenu && Input.GetKeyDown(KeyCode.Keypad6)) SceneManager.LoadScene(5);
        if (!useSelectorMenu && Input.GetKeyDown(KeyCode.Keypad7)) SceneManager.LoadScene(6);
        if (!useSelectorMenu && Input.GetKeyDown(KeyCode.Keypad8)) SceneManager.LoadScene(7);
        if (!useSelectorMenu && Input.GetKeyDown(KeyCode.Keypad9)) SceneManager.LoadScene(8);

        if (useSelectorMenu && Input.GetKeyDown(KeyCode.Escape)) SetSelectorMenuVisibilty(!isSelectorMenuOpen);

        if (!isSelectorMenuOpen && useFreeFlyCharacter && Input.GetKeyDown(KeyCode.Tab)) SetFreeFlyCharacterState(!isFreeFlyCharacterActive);
    }

    private void SetSelectorMenuVisibilty(bool newValue)
    {
        if (!useSelectorMenu || selectorMenu == null)
        {
            isSelectorMenuOpen = false;
            controlPanel.SetActive(true);
            return;
        }

        controlPanel.SetActive(!newValue);
        selectorMenu.SetActive(newValue);
        isSelectorMenuOpen = newValue;

        freeFlyCharacter.SetIgnoreMouse(newValue);

        Cursor.lockState = newValue ? Cursor.lockState = CursorLockMode.None : CursorLockMode.Locked;

        Time.timeScale = isSelectorMenuOpen ? 0 : 1f;
    }

    private void SetFreeFlyCharacterState(bool newValue)
    {
        if (!useFreeFlyCharacter || freeFlyCharacter == null)
        {
            isFreeFlyCharacterActive = false;
            mainCamera.enabled = true;
            if (freeFlyCharacter != null)
            {
                freeFlyCamera.enabled = false;
                freeFlyCharacter.gameObject.SetActive(false);
            }
            return;
        }

        Cursor.lockState = newValue ? CursorLockMode.Locked : Cursor.lockState = CursorLockMode.None;
        mainCamera.enabled = !newValue;
        freeFlyCamera.enabled = newValue;
        freeFlyCharacter.gameObject.SetActive(newValue);
        isFreeFlyCharacterActive = newValue;
    }
    public void ChangeScene(string sceneName)
    {
        SceneManager.LoadScene(sceneName);
    }
}
