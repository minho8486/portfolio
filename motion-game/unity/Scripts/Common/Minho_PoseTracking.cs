using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Minho_PoseTracking : MonoBehaviour
{
    public UDPReceive udpReceive;
    public GameObject[] PosePoints;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        string data = udpReceive.data;
        // print(data);

        data = data.Remove(0, 1);
        data = data.Remove(data.Length - 1, 1);
        string[] points = data.Split(',');

        for (int i = 0; i < 33; i++)
        {

            float x = 7 - float.Parse(points[i * 3]) / 100;
            float y = float.Parse(points[i * 3 + 1]) / 100;
            float z = float.Parse(points[i * 3 + 2]) / 300;

            PosePoints[i].transform.localPosition = new Vector3(x, y, z);

        }
    }
}
