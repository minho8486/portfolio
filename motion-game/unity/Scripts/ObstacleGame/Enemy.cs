using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    [SerializeField]
    private float movespeed = 10f;
    private float minZ = -5f;
    
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
        transform.position += new Vector3(0,0,-1) * movespeed * Time.deltaTime;
        if (transform.position.z < minZ)
        {
            Destroy(gameObject);
        }
    }
}
