using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

public class Manager : MonoBehaviour
{
    public static Manager instance = null;
    public float Timer, timer2;
    public bool success = false;

    [SerializeField]
    private TextMeshProUGUI text2;

    [SerializeField]
    private TextMeshProUGUI text;

    [SerializeField]
    private GameObject gameOverPanel;

    [SerializeField]
    private GameObject gameSuccessPanel;

    [SerializeField]
    private GameObject timePanel;

    [SerializeField]
    private GameObject scorePanel;

    [SerializeField]
    private GameObject ExplainPanel;

    private int HP = 5;

    void Start()
    {
        Invoke("HideExplainPanel", 10f);
    }

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
    }

    void Update()
    {

        Timer += Time.deltaTime;
        
        text2.SetText(Timer.ToString());
        if (Timer >= 40 && HP > 0)
        {
            SetSuccessTrue();
            if (success == true)
            {
                timer2 += Time.deltaTime;
                SetSuccess();

                if (timer2 >= 5)
                {
                    SceneManager.LoadScene("6to7");
                    timer2 = 0;
                }
            }
        }
    }

    public void HPcount()
    {
        HP -= 1;
        text.SetText(HP.ToString());
    }

    public void SetSuccessTrue()
    {
        success = true;
    }

    public void SetSuccess()
    {
        EnemySpawner enemySpawner = FindObjectOfType<EnemySpawner>();
        if (enemySpawner != null)
        {
            enemySpawner.StopEnemyRoutine();
        }
        Invoke("ShowSuccessPanel", 1f);
        Invoke("HideTimePanel", 1f);
        Invoke("HideScorePanel", 1f);
        Timer += Time.deltaTime;
        
    }

    public void SetGameOver()
    {
        EnemySpawner enemySpawner = FindObjectOfType<EnemySpawner>();
        if (enemySpawner != null)
        {
            enemySpawner.StopEnemyRoutine();
        }
        if (success == false)
        {
            Invoke("ShowGameOverPanel", 1f);
            Invoke("PlayAgain", 5f);
        }
    }

    void ShowGameOverPanel()
    {
        gameOverPanel.SetActive(true);
    }

    void ShowSuccessPanel()
    {
        gameSuccessPanel.SetActive(true);
    }

    void HideTimePanel()
    {
        timePanel.SetActive(false);
    }

    void HideScorePanel()
    {
        scorePanel.SetActive(false);
    }

    void HideExplainPanel()
    {
        ExplainPanel.SetActive(false);
    }

    public void PlayAgain()
    {
        SceneManager.LoadScene("(6)Minho");
    }
}
