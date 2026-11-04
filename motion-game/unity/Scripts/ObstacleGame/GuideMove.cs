using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuideMove : MonoBehaviour
{
    private float movespeed = 10f;
    private float minZ = -105f;

    public void SetMoveSpeed(float movespeed)
    {
        this.movespeed = movespeed;
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.position += new Vector3(0, 0, -1) * movespeed * Time.deltaTime;
        if (transform.position.z < minZ)
        {
            transform.position += new Vector3(0, 0, 210);
        }
    }
}
