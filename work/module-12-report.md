# Module 12 Completion Report

## Instruction File
- Filename: `instructions/calculate-compound-interest.agent.md`

````markdown
- Use this instruction as a routing pointer when asked to calculate compound interest with the project CLI.
- Follow `./instructions/calculate-compound-interest/SKILL.md` for required inputs, command syntax, validation, and result presentation.
````

## Script File
- Filename: `tools/compound_interest.py`
- Language: Python

```python
"""Calculate compound interest from command-line inputs."""

import argparse
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP


def parse_decimal(value: str) -> Decimal:
    try:
        number = Decimal(value)
    except InvalidOperation as error:
        raise argparse.ArgumentTypeError("must be a valid number") from error
    if not number.is_finite():
        raise argparse.ArgumentTypeError("must be a finite number")
    return number


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Calculate compound interest and the final amount."
    )
    parser.add_argument("principal", type=parse_decimal, help="starting amount")
    parser.add_argument(
        "annual_rate",
        type=parse_decimal,
        help="annual interest rate as a percentage (for example, 7.34 for 7.34%%)",
    )
    parser.add_argument(
        "compounds_per_year",
        type=int,
        help="number of compounding periods per year",
    )
    parser.add_argument("years", type=parse_decimal, help="investment duration in years")
    return parser.parse_args()


def main() -> None:
    args = parse_arguments()

    if args.principal < 0:
        raise SystemExit("error: principal must not be negative")
    if args.compounds_per_year <= 0:
        raise SystemExit("error: compounds_per_year must be a positive integer")
    if args.years < 0:
        raise SystemExit("error: years must not be negative")

    periodic_rate = args.annual_rate / Decimal(100 * args.compounds_per_year)
    if periodic_rate <= -1:
        raise SystemExit("error: annual_rate makes the periodic growth factor non-positive")

    periods = Decimal(args.compounds_per_year) * args.years
    try:
        amount = args.principal * (Decimal(1) + periodic_rate) ** periods
    except (InvalidOperation, OverflowError) as error:
        raise SystemExit("error: unable to calculate with the supplied values") from error

    interest = amount - args.principal
    rounded_amount = amount.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
    rounded_interest = interest.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)

    print(f"Final amount: ${rounded_amount:,.2f}")
    print(f"Interest earned: ${rounded_interest:,.2f}")


if __name__ == "__main__":
    main()
```

## Script Execution Output
```text
usage: compound_interest.py [-h]
                            principal annual_rate
                            compounds_per_year years

Calculate compound interest and the final amount.

positional arguments:
  principal           starting amount
  annual_rate         annual interest rate as a percentage (for
                      example, 7.34 for 7.34%)
  compounds_per_year  number of compounding periods per year
  years               investment duration in years

options:
  -h, --help          show this help message and exit
```
