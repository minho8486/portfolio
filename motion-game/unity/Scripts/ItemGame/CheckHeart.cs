using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckHeart : MonoBehaviour
{

    public Renderer cubeColor;

    public GameObject Lion;
    public GameObject Scarecrow;
    public GameObject Woodcutter;

    public GameObject item;
    public GameObject answer;

    public bool hea = false;
    public bool bra = false;
    public bool pot = false;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        hea = item.GetComponent<TriggerCheck>().ansheart;
        bra = item.GetComponent<TriggerCheck>().ansbrain;
        pot = item.GetComponent<TriggerCheck>().anspotion;
    }

    private void OnTriggerEnter(Collider col)
    {
        if (hea == true)
        {
            if (col.gameObject.tag == "Lion" && answer.GetComponent<GameClear>().answer1 == false)
            {
                Debug.Log("wrong");
                cubeColor = Lion.GetComponent<Renderer>();
                cubeColor.material.color = Color.red;
            }
            else if (col.gameObject.tag == "Scarecrow" && answer.GetComponent<GameClear>().answer2 == false)
            {
                Debug.Log("wrong");
                cubeColor = Scarecrow.GetComponent<Renderer>();
                cubeColor.material.color = Color.red;
            }
            else if (col.gameObject.tag == "Woodcutter")
            {
                Debug.Log("right");
                cubeColor = Woodcutter.GetComponent<Renderer>();
                cubeColor.material.color = Color.green;
                answer.GetComponent<GameClear>().answer3 = true;
            }
        }
        else if (bra == true)
        {
            if (col.gameObject.tag == "Lion" && answer.GetComponent<GameClear>().answer1 == false)
            {
                Debug.Log("wrong");
                cubeColor = Lion.GetComponent<Renderer>();
                cubeColor.material.color = Color.red;
            }
            else if (col.gameObject.tag == "Scarecrow")
            {
                Debug.Log("right");
                cubeColor = Scarecrow.GetComponent<Renderer>();
                cubeColor.material.color = Color.green;
                answer.GetComponent<GameClear>().answer2 = true;
            }
            else if (col.gameObject.tag == "Woodcutter" && answer.GetComponent<GameClear>().answer3 == false)
            {
                Debug.Log("wrong");
                cubeColor = Woodcutter.GetComponent<Renderer>();
                cubeColor.material.color = Color.red;
            }
        }
        else if (pot == true)
        {
            if (col.gameObject.tag == "Lion")
            {
                Debug.Log("right");
                cubeColor = Lion.GetComponent<Renderer>();
                cubeColor.material.color = Color.green;
                answer.GetComponent<GameClear>().answer1 = true;
            }
            else if (col.gameObject.tag == "Scarecrow" && answer.GetComponent<GameClear>().answer2 == false)
            {
                Debug.Log("wrong");
                cubeColor = Scarecrow.GetComponent<Renderer>();
                cubeColor.material.color = Color.red;
            }
            else if (col.gameObject.tag == "Woodcutter" && answer.GetComponent<GameClear>().answer3 == false)
            {
                Debug.Log("wrong");
                cubeColor = Woodcutter.GetComponent<Renderer>();
                cubeColor.material.color = Color.red;
            }
        }
    }
}
