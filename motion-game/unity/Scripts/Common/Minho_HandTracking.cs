
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Minho_HandTracking : MonoBehaviour
{
    // Start is called before the first frame update
    public UDPReceive udpReceive;
    public GameObject[] handPoints;

    public float point8X;
    public float point8Y;
    public float point8Z;


    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        string data = udpReceive.data;

        data = data.Remove(0, 1);
        data = data.Remove(data.Length - 1, 1);
        //print(data);
        string[] points = data.Split(',');
        //print(points[0]);

        point8X = 7 - float.Parse(points[(8+33) * 3]) / 100;
        point8Y = float.Parse(points[(8+33) * 3 + 1]) / 100;
        point8Z = float.Parse(points[(8+33) * 3 + 2]) / 100;


        for (int i = 0; i < 21; i++)
        {

            float x = 7 - float.Parse(points[(i+33) * 3]) / 100;
            float y = float.Parse(points[(i+33) * 3 + 1]) / 100;
            float z = float.Parse(points[(i+33) * 3 + 2]) / 100;

            handPoints[i].transform.localPosition = new Vector3(x, y, z);

        }


    }



}