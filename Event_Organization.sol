// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 < 0.9.0;

contract Events{ 
struct Event{
    address organizer;
    string name;
    uint date;
    uint price;
    uint ticketcount;
    uint ticketremaining;

}

mapping(uint => Event) public events;
mapping(address=>mapping (uint=>uint)) public tickets;
uint public nextId;

function createEvent(string memory name,uint date,uint price,uint ticketcount)external {
    require(date>block.timestamp,"You can organize event for future date0");
    require(ticketcount>0,"You can organize event only you create more than 0 tickets");

    events[nextId] = Event(msg.sender,name,date,price,ticketcount,ticketcount);
    nextId++;
}

function buyTicket(uint id, uint quantity) external payable {
    require(events[id].date!=0, "event does not exists");
    require(events[id].date>block.timestamp,"event has already occured");
    Event storage _event = events[id];

    require(msg.value==(_event.price*quantity),"there is not enough quantity");
    require(_event.ticketremaining>=quantity,"not enough tickets");
    _event.ticketremaining-=quantity;
    tickets[msg.sender][id]+=quantity;
}

 function Transferticket(uint id, uint quantity, address to) external {
    require(events[id].date!=0, "event does not exists");
    require(events[id].date>block.timestamp,"event has already occured");
    require(tickets[msg.sender][id]>=quantity,"you do not have enough tickets");
    tickets[msg.sender][id]-=quantity;
    tickets[to][id]+=quantity;
 }

}

