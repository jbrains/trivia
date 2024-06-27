/**
 * OpenAPI definition
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * The version of the OpenAPI document: v0
 * 
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */
import { PlayerDto } from './player-dto';
import { QuestionDto } from './question-dto';


export interface GameResponseDto { 
    id: number;
    name: string;
    state: string;
    turn: number;
    creator: PlayerDto;
    players: Array<PlayerDto>;
    currentPlayer: PlayerDto;
    winner?: PlayerDto;
    currentQuestion?: QuestionDto;
    currentRoll?: number;
}

