using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using TMPro;
using UnityEngine;

public class Minho_PlayerMove : MonoBehaviour
{

    [SerializeField]
    private GameObject LeftPanel;

    [SerializeField]
    private GameObject RightPanel;

    [SerializeField]
    private GameObject JumpPanel;

    [SerializeField]
    private GameObject CrashedPanel;

    [SerializeField]
    private GameObject Player;

    public Material[] mat = new Material[2];

    private float Timer;

    public GameObject hp;

    // Start is called before the first frame update
    public UDPReceive udpReceive;
    public GameObject[] PosePoints;
    // public GameObject udp;

    private Rigidbody rigidbody;
    private Vector3 dir = Vector3.zero;

    private bool ground = false;
    public LayerMask layer;

    public float speed = 15f;
    public float jumpHeight = 3f;

    public float data9Y;
    public float data11Y;
    public float data12Y;
    public float data13Y;
    public float data14Y;
    public float data15Y;
    public float data16Y;
    public float data19Y;
    public float data20Y;

    public int gap = 40;

    public float CharacterHP = 5f;

    void Start()
    {
        rigidbody = GetComponent<Rigidbody>();
        // udpReceive = UDPReceive.Find("udp");
        // udpReceive = udp.GetComponent<UDPReceive>();
    }

    // Update is called once per frame
    void Update()
    {
        Timer += Time.deltaTime;

        string data = udpReceive.data;

        data = data.Remove(0, 1);
        data = data.Remove(data.Length - 1, 1);
        print(data);
        string[] points = data.Split(',');

        data9Y = float.Parse(points[9 * 3 + 1]);
        data11Y = float.Parse(points[11 * 3 + 1]);
        data12Y = float.Parse(points[12 * 3 + 1]);
        data13Y = float.Parse(points[13 * 3 + 1]);
        data14Y = float.Parse(points[14 * 3 + 1]);
        data15Y = float.Parse(points[15 * 3 + 1]);
        data16Y = float.Parse(points[16 * 3 + 1]);
        data19Y = float.Parse(points[19 * 3 + 1]);
        data20Y = float.Parse(points[20 * 3 + 1]);

        for (int i = 0; i < 33; i++)
        {
            float x = float.Parse(points[i * 3]) / 200;
            float y = float.Parse(points[i * 3 + 1]) / 200;
            float z = float.Parse(points[i * 3 + 2]) / 200;

            PosePoints[i].transform.localPosition = new Vector3(x, y, z);
        }

        CheckGround();

        if (data9Y < data19Y && data9Y < data20Y && ground)
        {
            ShowJumpPanel();
            print("jump");
            Vector3 jumpPower = Vector3.up * jumpHeight;
            rigidbody.AddForce(jumpPower, ForceMode.VelocityChange);
            Invoke("CloseJumpPanel", 1f);
        }
        else if (data13Y - gap <= data11Y && data13Y + gap >= data11Y && data15Y - gap <= data11Y && data15Y + gap >= data11Y)
        {
            ShowLeftPanel();
            print("left");
            dir.x = -1;
            rigidbody.AddForce(dir * speed);
            Invoke("CloseLeftPanel", 1f);
        }
        else if (data14Y - gap <= data12Y && data14Y + gap >= data12Y && data16Y - gap <= data12Y && data16Y + gap >= data12Y)
        {
            ShowRightPanel();
            print("right");
            dir.x = 1;
            rigidbody.AddForce(dir * speed);
            Invoke("CloseRightPanel", 1f);
        }
    }

    void CheckGround()
    {
        RaycastHit hit;

        if (Physics.Raycast(transform.position + (Vector3.up * 0.2f), Vector3.down, out hit, 0.4f, layer))
        {
            ground = true;
        }
        else
        {
            ground = false;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag == "Enemy")
        {
            if (Timer <= 40)
            {
                ShowCrashedPanel();
                Invoke("CloseCrashedPanel", 1f);
                StartCoroutine(Damage());
                CharacterHP -= 1;
                hp.GetComponent<Manager>().HPcount();
                if (CharacterHP <= 0)
                {
                    hp.GetComponent<Manager>().SetGameOver();
                    Destroy(gameObject);
                }
            }
        }
    }

    IEnumerator Damage()
    {
        for (int i = 0; i <= 1; i++)
        {
            Player.GetComponent<MeshRenderer>().material = mat[0];
            yield return new WaitForSeconds(0.1f);
            Player.GetComponent<MeshRenderer>().material = mat[1];
            yield return new WaitForSeconds(0.1f);
        }
    }

    void ShowLeftPanel()
    {
        LeftPanel.SetActive(true);
    }

    void ShowRightPanel()
    {
        RightPanel.SetActive(true);
    }

    void ShowJumpPanel()
    {
        JumpPanel.SetActive(true);
    }

    void ShowCrashedPanel()
    {
        CrashedPanel.SetActive(true);
    }

    void CloseLeftPanel()
    {
        LeftPanel.SetActive(false);
    }

    void CloseRightPanel()
    {
        RightPanel.SetActive(false);
    }

    void CloseJumpPanel()
    {
        JumpPanel.SetActive(false);
    }

    void CloseCrashedPanel()
    {
        CrashedPanel.SetActive(false);
    }
}