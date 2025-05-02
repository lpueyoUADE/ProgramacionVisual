using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Keypad1)) SceneManager.LoadScene(0);
        if (Input.GetKeyDown(KeyCode.Keypad2)) SceneManager.LoadScene(1);
        if (Input.GetKeyDown(KeyCode.Keypad3)) SceneManager.LoadScene(2);
        if (Input.GetKeyDown(KeyCode.Keypad4)) SceneManager.LoadScene(3);
        if (Input.GetKeyDown(KeyCode.Keypad5)) SceneManager.LoadScene(4);
        if (Input.GetKeyDown(KeyCode.Keypad6)) SceneManager.LoadScene(5);
        if (Input.GetKeyDown(KeyCode.Keypad7)) SceneManager.LoadScene(6);
        if (Input.GetKeyDown(KeyCode.Keypad8)) SceneManager.LoadScene(7);
        if (Input.GetKeyDown(KeyCode.Keypad9)) SceneManager.LoadScene(8);
    }
}
