using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    public float speed;

    void Update()
    {
        Vector3 direction = new Vector3(
            Input.GetAxis("Horizontal"), 
            0, 
            Input.GetAxis("Vertical")
        );

        transform.position += speed * Time.deltaTime * direction;

        transform.position += Vector3.up * Mathf.Sin(Time.time * 6) * Time.deltaTime;
    }
}
