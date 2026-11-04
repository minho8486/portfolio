using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

public class GameClear : MonoBehaviour
{
    [SerializeField]
    private GameObject gameClearPanel;

    [SerializeField]
    private GameObject ExplainPanel;

    public bool answer1;
    public bool answer2;
    public bool answer3;

    public float Timer, Timer2;

    public GameObject heart;
    public GameObject brain;
    public GameObject potion;

    // Start is called before the first frame update
    void Start()
    {
        answer1 = false;
        answer2 = false;
        answer3 = false;
    }

    // Update is called once per frame
    void Update()
    {
        Timer2 += Time.deltaTime;
        if(Timer2 >= 10)
        {
            ExplainPanel.SetActive(false);
        }
        if (answer3 == true)
        {
            heart.transform.position = new Vector3(5f, 0.4f, 0f);
        }

        if (answer2 == true)
        {
            brain.transform.position = new Vector3(0f, -0.1f, 0f);
        }

        if (answer1 == true)
        {
            potion.transform.position = new Vector3(-5f, 0.6f, 0f);
        }

        if (answer1 == true && answer2 == true && answer3 == true)
        {
            Timer += Time.deltaTime;
            Invoke("ClearPanelOn", 5f);
            if (Timer >= 8)
            {
                SceneManager.LoadScene("7to8");
            }
        }
    }

    public void ClearPanelOn()
    {
        gameClearPanel.SetActive(true);
    }

}
