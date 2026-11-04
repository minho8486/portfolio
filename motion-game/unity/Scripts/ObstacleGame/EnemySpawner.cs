using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class EnemySpawner : MonoBehaviour
{

    [SerializeField]
    private GameObject[] enemies;

    private float[] arrPosX = { -3f, 3f };

    [SerializeField]
    private float spawnInterval = 1.5f;

    // Start is called before the first frame update
    void Start()
    {
        Invoke("StartEnemyRoutine",10f);
    }

    void StartEnemyRoutine()
    {
        StartCoroutine("EnemyRoutine");
    }

    public void StopEnemyRoutine()
    {
        StopCoroutine("EnemyRoutine");
    }

    IEnumerator EnemyRoutine()
    {
        yield return new WaitForSeconds(3f);

        while (true)
        {
            int index = Random.Range(0, enemies.Length);
            if (index == 0)
            {
                int posX = Random.Range(0, arrPosX.Length);
                SpawnEnemy(arrPosX[posX], 1, index);
            }
            else
            {
                SpawnEnemy(0, 0, index);
            }

            yield return new WaitForSeconds(spawnInterval);
        }
    }

    void SpawnEnemy(float posX, int posY, int index)
    {
        Vector3 spawnPos = new Vector3(posX, posY, transform.position.z);
        Instantiate(enemies[index], spawnPos, Quaternion.identity);
    }
}