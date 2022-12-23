enum typeEnum {
    Yorkshire = 1,
    Lean = 2,
    Potbelly = 3
}

interface Dejimon {
    id?: number;
    name: string;
    type: typeEnum;
    height: number;
    weight: number;
    ability: number;
    overall: number;
}

