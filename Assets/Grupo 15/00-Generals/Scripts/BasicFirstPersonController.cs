using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BasicFirstPersonController : MonoBehaviour
{
    public Camera freeFlyCamera;

    public float moveSpeed = 5f;
    public float mouseSensitivity = 2f;
    public float gravity = -9.81f;
    public bool useGravity = false;

    private CharacterController controller;
    private float xRotation = 0f;
    private float verticalVelocity = 0f;

    private bool isIngoringMouse;
    void Start()
    {
        isIngoringMouse = false;
        controller = GetComponent<CharacterController>();
    }

    void Update()
    {
        // --- Rotacion del mouse ---
        float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity;
        float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity;

        xRotation -= mouseY * (isIngoringMouse ? 0 : 1);
        xRotation = Mathf.Clamp(xRotation, -90f, 90f);
        freeFlyCamera.transform.localRotation = Quaternion.Euler(xRotation, 0f, 0f);

        transform.Rotate(Vector3.up * mouseX * (isIngoringMouse ? 0 : 1));

        // --- Movimiento en la direccion donde mira la camara ---
        float moveX = Input.GetAxis("Horizontal");
        float moveZ = Input.GetAxis("Vertical");

        // Direccion basada en la orientacion de la camara
        Vector3 moveDirection = freeFlyCamera.transform.forward * moveZ + freeFlyCamera.transform.right * moveX;
        controller.Move(moveDirection * moveSpeed * Time.deltaTime);

        // --- Movimiento vertical (solo si no usa gravedad) ---
        if (!useGravity)
        {
            if (Input.GetKey(KeyCode.Space)) moveDirection += Vector3.up;
            if (Input.GetKey(KeyCode.LeftShift)) moveDirection += Vector3.down;
        }

        Vector3 move = moveDirection * moveSpeed;

        // --- Aplicar gravedad si corresponde ---
        if (useGravity)
        {
            if (controller.isGrounded && verticalVelocity < 0)
                verticalVelocity = -2f;
            else
                verticalVelocity += gravity * Time.deltaTime;

            move.y = verticalVelocity;
        }

        controller.Move(move * Time.deltaTime);
    }

    public void SetIgnoreMouse(bool ignore)
    {
        isIngoringMouse = ignore;
    }
}
