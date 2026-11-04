using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Minho_ChangeColor : MonoBehaviour
{
    public GameObject obj;

    public Transform object1; // 첫 번째 오브젝트
    public Transform object2; // 두 번째 오브젝트
    public float closeDistance = 0.5f; // 가까운 거리

    public bool hearttrig = false;
    public bool braintrig = false;
    public bool potiontrig = false;

    public GameObject Heart;
    public GameObject Brain;
    public GameObject Potion;

    public float P8X;
    public float P8Y;
    public float P8Z;

    public bool OK = false;

    void Update()
    {
        float distance = Vector3.Distance(object1.position, object2.position); // 두 오브젝트 간의 거리 계산

        P8X = obj.GetComponent<Minho_HandTracking>().point8X;
        P8Y = obj.GetComponent<Minho_HandTracking>().point8Y;
        P8Z = obj.GetComponent<Minho_HandTracking>().point8Z;


        if (distance < closeDistance) // 거리가 가까운 거리보다 작거나 같은 경우
        {
            //Debug.Log("OK"); // 콘솔에 "OK" 출력
            OK = true;

            if (hearttrig == true)
            {
                Heart.transform.position = new Vector3(P8X, P8Y, P8Z);
            }
            else if (braintrig == true)
            {
                Brain.transform.position = new Vector3(P8X, P8Y, P8Z);
            }
            else if (potiontrig == true)
            {
                Potion.transform.position = new Vector3(P8X, P8Y, P8Z);
            }
        }
        else
        {
            OK = false;
            AllFalse();
        }
    }

    public void HeartTrue()
    {
        hearttrig = true;
        braintrig = false;
        potiontrig = false;
    }

    public void BrainTrue()
    {
        hearttrig = false;
        braintrig = true;
        potiontrig = false;
    }

    public void PotionTrue()
    {
        hearttrig = false;
        braintrig = false;
        potiontrig = true;
    }

    public void AllFalse()
    {
        hearttrig = false;
        braintrig = false;
        potiontrig = false;
    }
}