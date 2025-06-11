using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MatrixController : MonoBehaviour
{
    [SerializeField]
    GameObject element;

    [SerializeField]
    int columns=1;

    [SerializeField]
    int rows=1;

    [SerializeField]
    float columnGap = 1;

    [SerializeField]
    float rowGap = 1;


    private void Start()
    {
        for (int i = 0; i < columns; i++)
        {
            for(int j = 0; j < rows; j++)
            {
                Instantiate(element, transform.position + new Vector3(i * columnGap, 0, j * rowGap), Quaternion.identity);
            }
        }
    }
}
