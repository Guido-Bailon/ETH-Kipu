//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/**
	*@title Contrato Donations
	*@notice Este es un contrato con fines educativos.
	*@author i3arba - 77 Innovation Labs
	*@custom:security No usar en producción.
*/
contract Donations {

	/*///////////////////////
					Variables
	///////////////////////*/
	///@notice variable inmutable para almacenar la dirección que debe retirar las donaciones
	address immutable i_receiver; //Inmutable solo pueden ser asignados en el constructor
	
	///@notice mapping para almacenar el valor donado por usuario
	mapping(address user => uint256 value) public s_donations;
	
	/*///////////////////////
						Events
	////////////////////////*/
	///@notice evento emitido cuando se realiza una nueva donación
	event Donations_DonationReceived(address donator, uint256 value);
	///@notice evento emitido cuando se realiza un retiro
	event Donations_Withdrawal(address receiver, uint256 value);
	
	/*///////////////////////
						Errors
	///////////////////////*/
	///@notice error emitido cuando falla una transacción
	error Donations_TransferError(bytes erro);
	///@notice error emitido cuando una dirección diferente al beneficiario intenta retirar
	error Donations_AddressNotAllowed(address caller, address receiver);
	
	/*///////////////////////
					Functions
	///////////////////////*/
	constructor(address _receiver){ //Se ejecuta una única vez 
		i_receiver = _receiver;
	}
	
	
	///@notice función para recibir ether directamente
	receive() external payable{
        this.donate();
    }
	fallback() external{} 
	
	/**
		*@notice función para recibir donaciones
		*@dev esta función debe sumar el valor donado por cada dirección a lo largo del tiempo
		*@dev esta función debe emitir un evento informando la donación.
	*/
	function donate() external payable {
		s_donations[msg.sender] = s_donations[msg.sender] += msg.value; //msg.sender es el address de la wallet o contracto utilizando el contrato
	
		emit Donations_DonationReceived(msg.sender, msg.value);
	}
	
	/*
		*@notice función para retirar el valor de las donaciones
		*@notice el valor del retiro debe ser el valor de la nota enviada
		*@dev solo el beneficiario puede retirar
		*@param _id El ID de la nota fiscal
		*@param _valor El valor de la nota fiscal
	*/
	function withdraw(uint256 _value) external {
		if(msg.sender != i_receiver) revert Donations_AddressNotAllowed(msg.sender, i_receiver);
		
		emit Donations_Withdrawal(msg.sender, _value);
		
		_transferEth(_value);
	}
	
	/*
		*@notice función privada para realizar la transferencia del ether
		*@param _value El valor a ser transferido
		*@dev debe revertir si falla
	*/
	function _transferEth(uint256 _value) private {
		(bool success, bytes memory erro) = msg.sender.call{value: _value}("");
		if(!success) revert Donations_TransferError(erro); //Una posible manera de manejar errores: if+revert error()
	}
}
