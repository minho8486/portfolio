using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerCheck : MonoBehaviour
{
    public GameObject hand;

    public bool ansheart = false;
    public bool ansbrain = false;
    public bool anspotion = false;


    public bool OKfinger = false;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        OKfinger = hand.GetComponent<Minho_ChangeColor>().OK;
    }

    private void OnTriggerEnter(Collider col)
    {
        if (col.gameObject.tag == "Heart")
        {
            Debug.Log("Heart");
            hand.GetComponent<Minho_ChangeColor>().HeartTrue();
            HeartCheck();
        }
        else if (col.gameObject.tag == "Brain")
        {
            Debug.Log("Brain");
            hand.GetComponent<Minho_ChangeColor>().BrainTrue();
            BrainCheck();
        }
        else if (col.gameObject.tag == "Potion")
        {
            Debug.Log("Potion");
            hand.GetComponent<Minho_ChangeColor>().PotionTrue();
            PotionCheck();
        }
    }

    public void HeartCheck()
    {
        ansheart = true;
        ansbrain = false;
        anspotion = false;
    }

    public void BrainCheck()
    {
        ansheart = false;
        ansbrain = true;
        anspotion = false;
    }

    public void PotionCheck()
    {
        ansheart = false;
        ansbrain = false;
        anspotion = true;
    }
}
