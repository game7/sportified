import { Statsheet, Action, Skater } from '../common/types'

export function reducer(state: Statsheet, action: Action) {
    console.log('action: ', action.type, action)
    switch(action.type) {
      case 'shots/updated':
      case 'periods/updated':      
        return {
          ...state,
          settings: action.payload
        }
      case 'goal/added':
        return {
          ...state,
          goals: [...state.goals, action.payload]
        }
      case 'goal/deleted':
        return {
          ...state,
          goals: state.goals.filter(g => g.id !== action.payload)
        }
      case 'penalty/created':
        return {
          ...state,
          penalties: [...state.penalties, action.payload]
        }
      case 'penalty/updated':
        return {
          ...state,
          penalties: state.penalties.map(obj => obj.id == action.payload.id ? action.payload : obj)
        }      
      case 'penalty/deleted':
        return {
          ...state,
          penalties: state.penalties.filter(obj => obj.id !== action.payload)
        }      
      case 'skaters/loaded':
        return {
          ...state,
          skaters: action.payload
        }
      case 'skater/updated':
        const updated = action.payload as Skater;
        return {
          ...state,
          skaters: state.skaters.map(obj => obj.id == action.payload.id ? action.payload : obj)
        }
      case 'skater/added':
        return {
          ...state,
          skaters: [...state.skaters, action.payload as Skater]
        }    
      case 'skater/deleted':
        return {
          ...state,
          skaters: state.skaters.filter(g => g.id !== action.payload)
        }  
      case 'goaltenders/loaded':
          return {
            ...state,
            goaltenders: action.payload
          }
      case 'goaltender/updated':
        return {
          ...state,
          goaltenders: state.goaltenders.map(obj => obj.id == action.payload.id ? action.payload : obj)
        }
      case 'goaltender/created':
        return {
          ...state,
          goaltenders: [...state.goaltenders, action.payload]
        }    
      case 'goaltender/deleted':
        return {
          ...state,
          goaltenders: state.goaltenders.filter(g => g.id !== action.payload)
        }                 
      default:
        throw `Action "${action.type}" not handled by reducer`
    }
  }