// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

contract ToDoList{
    /*
        Tipos
    */
    struct Task{
        string desc;
        uint256 creationDate; //Entero sin signo
        bool done;
    }
    Task[] public s_tasks; //Si no se indica el tamano es dinamico. Empieza desde 0. s_ pq se guarda en el storage

    /*
        Eventos
    */
    event ToDoList_addedTask(Task task);
    event ToDoList_taskCompleted(Task task);
    event ToDoList_taskCompleted(string description); //Hay sobrecarga, tambien se podria crear otro evento

    /*
        Funciones
    */
    function addTask(string memory _description) external { // adelante para indicar que es de memoria
        Task memory newTask = Task({                           // Funcion external para que sea accesible
            desc: _description,
            creationDate: block.timestamp,
            done: false
        });

        s_tasks.push(newTask);
        emit ToDoList_addedTask(newTask);
    }

    function getTask(uint256 _index) external view returns (Task memory _task){
        _task = s_tasks[_index];
    }

    function completeTask(uint256 _index) external{
        s_tasks[_index].done = true;

        emit ToDoList_taskCompleted(s_tasks[_index]);
    }

    function deleteTask(string memory _description) external{
        uint256 length = s_tasks.length;
        for (uint256 i=0; i<length; i++){
            if(keccak256(abi.encodePacked(_description)) == keccak256(abi.encodePacked(s_tasks[i].desc))){
                s_tasks[i] = s_tasks[length-1];
                s_tasks.pop();

                emit ToDoList_taskCompleted(_description);
                return;
            }

        }
    }
}