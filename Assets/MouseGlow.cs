using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseGlow : MonoBehaviour {
    private Camera mainCam;

    void Start () {
        mainCam = GetComponent<Camera>();
    }

    void Update () {
        Plane p = new Plane(Vector3.down, Vector3.zero);
        Vector2 mousePos = Input.mousePosition;
        Ray ray = mainCam.ScreenPointToRay(mousePos);
        if (p.Raycast(ray, out float enterDist) ){
            Vector3 worldMousePos= ray.GetPoint(enterDist);
            Shader.SetGlobalVector("_MousePos", worldMousePos);
        }
    }
}